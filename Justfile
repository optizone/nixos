# Provision remote host
@provision config host:
    # Update
    echo "'{{ host }}' age key:"
    ssh "root@{{ host }}" "cat /etc/ssh/ssh_host_ed25519_key.pub" \
        | ssh-to-age \
        | tee .__tmp_ssh_age_key

    sed -i "/{{ config }} age.*/d" .sops.yaml
    sed -i "/\*{{ config }}/d" .sops.yaml

    sed -i "2i\  - &{{ config }} $(cat .__tmp_ssh_age_key)" .sops.yaml
    echo "      - *{{ config }}" >> .sops.yaml
    rm .__tmp_ssh_age_key


    # Update secrets.yaml with new host key
    echo ""
    echo "### Updating keys ###"
    sops updatekeys secrets.yaml

    echo ""
    echo "### Provisioning ###"
    nixos-anywhere \
        --flake "./#{{ config }}" \
        --target-host root@{{ host }} \
        --no-substitute-on-destination \
        --option substitute false \
        --generate-hardware-config nixos-generate-config \
            ./hosts/{{ config }}/hardware-configuration.nix \
        --copy-host-keys \
        --phases kexec,disko,install

    # Copy ssh keys to persistent location 
    echo ""
    echo "### Copying SSH keys to persistent location ###"
    ssh "root@{{ host }}" "cp /etc/ssh/ssh_host_ed25519_key* /mnt/zroot/ldata/persist/{{ config }}/etc/ssh"

    # At this point configuration is done
    echo ""
    echo "### Rebooting ###"
    ssh "root@{{ host }}" "reboot"

# test connection speed to remote host
@cspeed host:
    ssh "{{ host }}@{{ host }}" "iperf -s1" &
    # TODO: wait for port 5201 to open
    sleep 1
    iperf -c {{ host }}

@restore-zigbee2mqtt host:
    rsync -r \
        --chown zigbee2mqtt:zigbee2mqtt \
        ~/zroot/ldata/backups/{{ host }}/latest/persist/var/lib/zigbee2mqtt \
        root@{{ host }}:/var/lib/

@edit-secrets:
    sops secrets.yaml

@make-password:
    mkpasswd -m sha-512

# overlayfs nix store onto persistent location
overlay:
    sudo chown -R root:nixbld /znode/persist/build/nix
    sudo chown -R root:nixbld /znode/persist/build/nix-workdir
    sudo mount -t overlay overlay \
      -olowerdir=/nix/store,upperdir=/znode/persist/build/nix,workdir=/znode/persist/build/nix-workdir \
      /nix/store

# nixos-rebuild aliases

# `nixos-rebuild build`
build host *args:
    nixos-rebuild build \
          --flake "./#{{ host }}" \
          {{ args }} \
          --fallback

# `nixos-rebuild test` remote host
test host *args:
    nixos-rebuild test \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          {{ args }} \
          --target-host "root@{{ host }}"

# `nixos-rebuild boot` remote host
boot host *args:
    nixos-rebuild boot \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          {{ args }} \
          --target-host "root@{{ host }}"

# `nixos-rebuild switch` remote host
switch host *args:
    nixos-rebuild switch \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          {{ args }} \
          --target-host "root@{{ host }}"

setup-vm vm="vm0":
    incus launch images:nixos/26.05 {{ vm }} --vm \
        -c security.secureboot=false \
        -c limits.memory=8GB \
        --device root,size=16GiB
    incus wait {{ vm }} agent
    @incus exec {{ vm }} -- sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config
    @incus exec {{ vm }} -- passwd
    @echo "inet info:"
    @incus info vm0 | grep inet | head -n 3

install:
    #!/usr/bin/env bash

    read -r -p "Enter username (default: $(whoami)) " username
    username=${username:-$(whoami)}

    read -r -p "Enter hostname (default: $(hostname)) " hostname
    hostname=${hostname:-$(hostname)}

    read -r -p "Enter git username (default: $(git config get user.name)) " git_username
    git_username=${git_username:-"$(git config get user.name)"}

    read -r -p "Enter git email (default: $(git config get user.email)) " git_email
    git_email=${git_email:-"$(git config get user.email)"}

    echo "Generating hardware config..."
    hw_cfg_dir=$(mktemp -d)
    nixos-generate-config --dir $hw_cfg_dir
    cp $hw_cfg_dir/hardware-configuration.nix ./hosts/generic/hardware-configuration.nix

    sed -i "s/username = \"generic-user\"/username = \"$username\"/" flake.nix
    sed -i "s/host = \"generic-host\"/host = \"$hostname\"/" flake.nix
    sed -i "s/gitUsername = \"generic\"/gitUsername = \"$git_username\"/" flake.nix
    sed -i "s/gitEmail = \"generic@generic.gen\"/gitEmail = \"$git_email\"/" flake.nix

    read -r -p "Choose configuration (pc, laptop) " config

    echo "Ready to load config to your bootloader."
    read -r -p "Proceed? (type y) " y
    [ $y="y" ] && exit 0

    ln -s ./hosts/generic/$config.nix hosts/generic/default.nix 
    nixos-rebuild boot --dry --use-remote-sudo --flake ./#generic-$config

    read -r -p "Reboot? (type y) " y
    [ $y="y" ] || reboot
