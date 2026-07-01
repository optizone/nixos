{stateVersion, ...}: {
  nix = {
    settings = {
      auto-optimise-store = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    optimise = {
      automatic = true;
      dates = ["03:45"];
    };

    channel.enable = false;
  };

  system.stateVersion = "${stateVersion}";
}
