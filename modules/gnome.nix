{ config, lib, pkgs, ... }: {

  # OPTIONS
  options = {
    modules.gnome = {
      enable = lib.mkEnableOption "";
      powerManagement = lib.mkEnableOption "";
    };
  };
  
  # CONFIG
  config = lib.mkIf config.modules.gnome.enable {
    # Enable Gnome and GDM
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    # Configure services
    services = {
      xdg-portal-gnome.enable = true;
      gnome.core-utilities.enable = false;
      upower.enable = config.modules.gnome.powerManagement;
    };
  };

}