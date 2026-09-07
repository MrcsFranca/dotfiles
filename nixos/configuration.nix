# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  i3lockCmd = pkgs.writeShellScript "i3lock-wrapper" ''
    ${pkgs.i3lock-color}/bin/i3lock-color \
      --color=1a1e2a \
      --inside-color=1a1e2aff \
      --ring-color=5eadfcff \
      --line-uses-inside \
      --separator-color=6a6f87ff \
      --insidever-color=1d2430ff \
      --ringver-color=00fbadff \
      --insidewrong-color=1d2430ff \
      --ringwrong-color=fa5eadff \
      --verif-color=00fbadff \
      --wrong-color=fa5eadff \
      --time-color=ffffffff \
      --date-color=ffffffff \
      --layout-color=ffffffff \
      --keyhl-color=ffdf5fff \
      --bshl-color=fa5eadff \
      --time-str="%H:%M:%S" \
      --date-str="%A, %d de %B" \
      --time-font="JetBrainsMono Nerd Font" \
      --date-font="JetBrainsMono Nerd Font" \
      --clock \
      --indicator \
      --radius=150
  '';
in {
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
  services.displayManager.ly.settings = {
    animation = "matrix";
    bigclock = true;
  };

  programs.i3lock.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "br";

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    windowManager.qtile.enable = true;
    videoDrivers = ["nvidia"];
  };

  # autolock in suspend mode with xserver
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${i3lockCmd}";
  };
  services.xserver.xautolock = {
    enable = true;
    locker = "${i3lockCmd}";
    time = 15;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # ppowerManagement
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  # powerManagement notebook
  # services.upower.enable = true;
  #services.logind = {
  #  extraConfig = ''
  #    HandleLidSwitch=suspend
  #    HandlePowerKey=suspend
  #  '';
  #};

  users.users.marcos = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "docker" "vboxusers" "wireshark"];
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

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  networking.firewall.allowedTCPPorts = [6443];

  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    git
    curl
    btop
    brightnessctl
    openvpn
    update-resolv-conf
    i3lock-color
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
