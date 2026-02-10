{ config, pkgs, ... }:

{
    home.username = "marcos";
    home.homeDirectory = "/home/marcos";
    home.stateVersion = "25.11";

    programs.git.enable = true;
    services.syncthing.enable = true;
    programs.bash = {
        enable = true;
        shellAliases = {
            nv = "nvim";
        };
    };
    xdg.configFile."qtile" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/marcos/nixos/config/qtile/";
        recursive = true;
    };
    programs.firefox = {
        enable = true;
        profiles.marcos = {
    	    settings = {
    		"extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    		"layout.css.prefers-color-scheme.content-override" = 0;
    		"ui.systemUsesDarkTheme" = 1;
    		"devtools.theme" = "dark";
    		"browser.theme.content-theme" = 0;
    		"browser.theme.toolbar-theme" = 0;
	    };
      };
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
