# Provision remote host
@provision host:
    # Update
    echo "'{{host}}' age key:"
    ssh "root@{{host}}" "cat /etc/ssh/ssh_host_ed25519_key.pub" | nix run "nixpkgs#ssh-to-age" | tee .__tmp_ssh_age_key

    sed -i "/{{host}} age.*/d" .sops.yaml
    sed -i "/\*{{host}}/d" .sops.yaml

    sed -i "2i\  - &{{host}} $(cat .__tmp_ssh_age_key)" .sops.yaml
    echo "      - *{{host}}" >> .sops.yaml
    rm .__tmp_ssh_age_key


    # Update secrets.yaml with new host key
    echo ""
    echo "Updating keys:"
    nix run "nixpkgs#sops" updatekeys secrets.yaml

    echo ""
    echo "Provisioning:"
    nix run github:nix-community/nixos-anywhere -- \
        --flake "./#{{host}}" \
        --target-host root@{{host}} \
        --no-substitute-on-destination \
        --generate-hardware-config nixos-generate-config \
            ./hosts/{{host}}/hardware-configuration.nix \
        --copy-host-keys \
        --phases kexec,disko,install

    # Copy ssh keys to persistent location 
    echo ""
    echo "Copying SSH keys to persistent location..."
    ssh "root@{{host}}" "cp /etc/ssh/ssh_host_ed25519_key* /mnt/znode/persist/etc/ssh"

    # At this point configuration is done
    echo ""
    echo "Rebooting..."
    ssh "root@{{host}}" "reboot"

# test connection speed to remote host
@cspeed host:
    ssh "{{host}}@{{host}}" "iperf -s1" &
    # TODO: wait for port 5201 to open
    sleep 1
    iperf -c {{host}}

@restore-zigbee2mqtt host:
    rsync -r \
        --chown zigbee2mqtt:zigbee2mqtt \
        ~/zroot/ldata/backups/{{host}}/latest/persist/var/lib/zigbee2mqtt \
        root@{{host}}:/var/lib/

@edit-secrets:
     nix run "nixpkgs#sops" secrets.yaml

@secrets-mkpasswd:
    mkpasswd -m sha-512

# nixos-rebuild aliases

# `nixos-rebuild test` remote host
test host:
    nixos-rebuild-ng test \
          --use-remote-sudo \
          --ask-sudo-password \
          --flake "./#{{host}}" \
          --target-host "root@{{host}}" \
          --build-host "root@{{host}}"

# `nixos-rebuild boot` remote host
boot host:
    nixos-rebuild-ng boot \
          --use-remote-sudo \
          --ask-sudo-password \
          --flake "./#{{host}}" \
          --target-host "root@{{host}}" \
          --build-host "root@{{host}}"

# `nixos-rebuild switch` remote host
switch host:
    nixos-rebuild-ng switch \
          --use-remote-sudo \
          --ask-sudo-password \
          --flake "./#{{host}}" \
          --target-host "root@{{host}}" \
          --build-host "root@{{host}}"

# VM related

vm-build host:
   nixos-rebuild-ng build-vm 
