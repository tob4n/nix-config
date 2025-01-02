{ config, lib, pkgs, ... }: {

  # OPTIONS
  options = {
    modules.gnome = {
      enable = lib.mkEnableOption "";
    };
  };
  
  # CONFIG
  config = lib.mkIf config.modules.gnome.enable {
    # Enable GNOME and GDM
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Enable XDG desktop portal
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
    };

    # Disable GNOME core apps and setup
    services.gnome = {
      core-utilities.enable = false;
      gnome-initial-setup.enable = false;
    };

    # Disable the remaining apps
    environment.gnome.excludePackages = (with pkgs; [
      gnome-tour
      gnome-shell-extensions
    ]);

    # Force GDM to inherit GNOME scaling
    environment.etc."dconf/db/gdm.d/01-scaling" = {
      text = ''
        [org/gnome/desktop/interface]
        inherit-settings=true
      '';
    };

    system.activationScripts.dconfdb.text = ''
      ${pkgs.dconf}/bin/dconf update
    '';
  };

}
