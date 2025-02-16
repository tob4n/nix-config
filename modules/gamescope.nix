{ config, lib, pkgs, ... }: {

  # Enable Gamescope
  programs.gamescope = {
    enable = true;
    args = [
      "--fullscreen"
      "--backend drm" 
      "--immediate-flips"
      "--rt"
    ];
  };

  # Set capabilities for gamescope
  security.wrappers.gamescope = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_nice=eip";
    source = "${pkgs.gamescope}/bin/gamescope";
  };

}
