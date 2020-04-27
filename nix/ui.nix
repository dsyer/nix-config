{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    
  ];

  services = {
    xserver = {
      enable = true;
      layout = "gb";
      displayManager = {
        defaultSession = "xfce";
      };
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };
  };

}
