{ config,  ... }:

{
	hardware.graphics.enable = true;

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  
    modesetting.enable = true;
    nvidiaPersistenced = true;

    # enable if issues with sleep
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # open-source driver
    open = true;

    nvidiaSettings = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

}
