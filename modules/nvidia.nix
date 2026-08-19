{ config, ... }:

{
	hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  
    modesetting.enable = true;
    nvidiaPersistenced = true;

    # enable if issues with sleep
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # open-source driver
    open = true;

    nvidiaSettings = true;
  };

  boot = {
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [
      # "nvidia-drm.fbdev=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
  };
}
