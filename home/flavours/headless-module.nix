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
        ../headless.nix
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
      "networkmanager"
      "users"
      "wheel"
      "${username}"
    ];
    ignoreShellProgramCheck = true;
    inherit shell;
  };

  nix.settings.allowed-users = [ "${username}" ];
  nix.settings.trusted-users = [ "${username}" ];
}
