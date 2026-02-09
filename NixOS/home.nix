{ config, pkgs, ... }:

{
    home.username = "marcos";
    home.homeDirectory = "/home/marcos";
    programs.git.enable = true;
    home.stateVersion = "25.11";
    programs.bash = {
        enable = true;
        shellAliases = {
            btw = "echo i use nixos, btw";
            nv = "nvim";
        };
    };
    xdg.configFile."qtile" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/marcos/nixos-dotfiles/config/qtile/";
      recursive = true;
    };
    home.file.".config/nvim".source = ./config/nvim;
    home.file.".config/alacritty".source = ./config/alacritty;
    home.packages = with pkgs; [
      neovim
      nil
      nixpkgs-fmt
      gcc
      obsidian
      zotero
      ranger
      lynx
    ];
}
