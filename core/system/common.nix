{ pkgs, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
  ];
}
