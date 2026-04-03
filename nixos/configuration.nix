# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "catacombs";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "br-abnt2";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  programs.bash.promptInit = ''
    git_branch() {
      # Check if current directory is a Git repo
      if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        # Get the current branch name (shortened)
        local branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
            echo "$branch"
        fi
      fi
    }
    PS1="\n\[\033[01;34m\](\[\033[00m\]\[\033[01;31m\]\$(git_branch)\[\033[00m\]\[\033[01;34m\])\[\033[00m\]\[\033[01;36m\] \w\[\033[00m\]\[\033[01;32m\] → \[\033[00m\]"
    NIX_SHELL_PRESERVE_PROMPT=1
  '';

  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "br";

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    windowManager.qtile.enable = true;
  };

  users.users.marcos = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "docker" "vboxusers"];
    packages = with pkgs; [
      tree
    ];
  };

  services.sshd.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [];
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  services.k3s.enable = true;
  services.k3s.extraFlags = toString [
    "--write-kubeconfig-mode 644"
  ];
  systemd.services.k3s.wantedBy = lib.mkForce [];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["vboxusers"];

  networking.firewall.allowedTCPPorts = [6443];

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    git
    curl
    htop
    brightnessctl
    openvpn
    update-resolv-conf
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
