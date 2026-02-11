# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      tree
    ];
  };

  services.sshd.enable = true;
  virtualisation.docker.enable = true;
  services.k3s.enable = true;
  services.k3s.extraFlags = toString [
    "--write-kubeconfig-mode 644"
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    git
    curl
    htop
    k3s
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
