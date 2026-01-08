{ inputs, ... }:
{
  home.file."Pictures/wallpapers" = {
    source = inputs.wallpapers;
    recursive = true;
  };
}
