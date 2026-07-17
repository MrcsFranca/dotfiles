{
  config,
  pkgs,
  lib,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    alacritty = "alacritty";
  };
in {
  home.username = "marcos";
  home.homeDirectory = "/home/marcos";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    includes = [
      {
        path = "/home/marcos/.config/git/config.local";
      }
    ];
    settings = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
  services.syncthing.enable = true;
  #systemd.user.services.syncthing.Install.wantedBy = lib.mkForce [];
  programs.bash = {
    enable = true;
    shellAliases = {
      n = "nvim";
      w3m = "kitty -o window_padding_width=\"20 300\" -e w3m";
      w3 = "kitty -o window_padding_width=\"20 300\" -e w3m ddg.gg 2>/dev/null &";
      girus = "/home/marcos/.local/bin/girus";
    };

    initExtra = ''
      export VISUAL="nvim"
      export EDITOR="nvim"

      set -o vi
    '';
  };
  home.file.".inputrc".text = ''
    set show-mode-in-prompt on

    set vi-ins-mode-string "\1\e[1;32m\2[I]\1\e[0m\2 "
    set vi-cmd-mode-string "\1\e[1;34m\2[N]\1\e[0m\2 "
  '';

  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

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

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  home.packages = with pkgs; [
    #Personal
    obsidian
    flameshot
    mpv
    youtube-tui
    rofi
    w3m
    zotero
    spotify-player
    ranger
    # Development
    neovim
    kind
    burpsuite
    dbeaver-bin
    insomnia
    nil
    nixpkgs-fmt
    gcc
    unzip
    alejandra
    ripgrep
    nodejs_24
    # qt configuration for some GUI
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    usbutils
    net-tools
  ];
}
