# Provision remote host
@provision host:
    # Update
    echo "'{{ host }}' age key:"
    ssh "root@{{ host }}" "cat /etc/ssh/ssh_host_ed25519_key.pub" \
        | ssh-to-age \
        | tee .__tmp_ssh_age_key

    sed -i "/{{ host }} age.*/d" .sops.yaml
    sed -i "/\*{{ host }}/d" .sops.yaml

    sed -i "2i\  - &{{ host }} $(cat .__tmp_ssh_age_key)" .sops.yaml
    echo "      - *{{ host }}" >> .sops.yaml
    rm .__tmp_ssh_age_key


    # Update secrets.yaml with new host key
    echo ""
    echo "Updating keys:"
    sops updatekeys secrets.yaml

    echo ""
    echo "Provisioning:"
    nixos-anywhere \
        --flake "./#{{ host }}" \
        --target-host root@{{ host }} \
        --no-substitute-on-destination \
        --option substitute false \
        --generate-hardware-config nixos-generate-config \
            ./hosts/{{ host }}/hardware-configuration.nix \
        --copy-host-keys \
        --phases kexec,disko,install

    # Copy ssh keys to persistent location 
    echo ""
    echo "Copying SSH keys to persistent location..."
    ssh "root@{{ host }}" "cp /etc/ssh/ssh_host_ed25519_key* /mnt/zroot/ldata/persist/etc/ssh"

    # At this point configuration is done
    echo ""
    echo "Rebooting..."
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
build host:
    nixos-rebuild build \
          --flake "./#{{ host }}" \
          --fallback

# `nixos-rebuild test` remote host
test host:
    nixos-rebuild test \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          --fallback \
          --target-host "root@{{ host }}"

# `nixos-rebuild boot` remote host
boot host:
    nixos-rebuild boot \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          --fallback \
          --target-host "root@{{ host }}"

# `nixos-rebuild switch` remote host
switch host:
    nixos-rebuild switch \
          --sudo \
          --ask-sudo-password \
          --flake "./#{{ host }}" \
          --fallback \
          --target-host "root@{{ host }}"
