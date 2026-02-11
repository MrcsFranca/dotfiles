{ config, pkgs, ... }:
let
    dotfiles = "${config.home.homeDirectory}/nixos/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
        qtile = "qtile";
        nvim = "nvim";
        alacritty = "alacritty";
    };
in

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

    xdg.configFile = builtins.mapAttrs (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
    }) configs;

#    xdg.configFile."qtile" = {
#        source = create_symlink "${dotfiles}/qtile/";
#        recursive = true;
#    };
#    xdg.configFile."nvim" = {
#        source = create_symlink "${dotfiles}/nvim/";
#        recursive = true;
#    };
#    xdg.configFile."alacritty" = {
#        source = create_symlink "${dotfiles}/alacritty/";
#        recursive = true;
#    };
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
