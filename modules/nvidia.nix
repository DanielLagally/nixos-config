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
    # Driver requires the userspace nvidia-sleep.sh/procfs suspend interface
    # (confirmed via dmesg: "System Power Management attempted without driver
    # procfs suspend interface" -> nv_pmops_freeze returns -5 -> hibernate
    # fails instantly with EIO). Defaults to true for open+>=595, which skips
    # creating the nvidia-suspend/nvidia-hibernate/nvidia-resume systemd units.
    powerManagement.kernelSuspendNotifier = false;

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
      # NVreg_UseKernelSuspendNotifiers is now set via
      # hardware.nvidia.powerManagement.kernelSuspendNotifier above, not here
      # (https://github.com/NVIDIA/open-gpu-kernel-modules/issues/1142) -
      # doing it as a raw kernelParam skipped the systemd hooks the driver
      # actually needs once kernel suspend notifiers are off.
    ];
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend="yes";
    AllowHibernation="yes";
    AllowHybridSleep="no";
    AllowSuspendThenHibernate="yes";
  };
}
