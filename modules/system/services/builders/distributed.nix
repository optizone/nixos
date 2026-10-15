_: {
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "rpi5-k";
        system = "aarch64-linux,armv7l-linux,armv6l-linux";
        protocol = "ssh-ng";
        sshUser = "nixremotebuilder";
        # NOTE: calculeted via `base64 -w0 /etc/ssh/ssh_host_type_key.pub`
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJWWW9sY3U0SndkQXRZbUhIZzh5OUczb1RqYUtTSi9GUERCWERPdEpRM1cgcm9vdEBuaXhvcy1pbnN0YWxsZXIK";
        sshKey = "/home/thinkpad/.ssh/thinkpad";
        maxJobs = 3;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [];
      }

      {
        hostName = "rpi4-f";
        system = "aarch64-linux,armv7l-linux,armv6l-linux";
        protocol = "ssh-ng";
        sshUser = "nixremotebuilder";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJWWW9sY3U0SndkQXRZbUhIZzh5OUczb1RqYUtTSi9GUERCWERPdEpRM1cgcm9vdEBuaXhvcy1pbnN0YWxsZXIK";
        sshKey = "/home/thinkpad/.ssh/thinkpad";
        maxJobs = 3;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [];
      }
    ];
  };
}
