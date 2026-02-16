{
  inputs,
  username,
  specialArgs,
  shell,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    backupFileExtension = "bak";
    useGlobalPkgs = true;

    extraSpecialArgs = {
      inherit inputs;
    }
    // specialArgs;

    users.${username} = {
      imports = [
        ../default.nix
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "wireshark"
      "networkmanager"
      "users"
      "wheel"
    ];
    ignoreShellProgramCheck = true;
    inherit shell;
  };

  nix.settings.allowed-users = [ "${username}" ];
  nix.settings.trusted-users = [ "${username}" ];
}
