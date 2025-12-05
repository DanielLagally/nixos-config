{ config, pkgs, ... }:
let
  drm_fop_flags_patch = pkgs.fetchpatch {
    url    = "https://github.com/Binary-Eater/open-gpu-kernel-modules/commit/8ac26d3c66ea88b0f80504bdd1e907658b41609d.patch";
    sha256 = "0+SfIu3uYNQCf/KXhv4PWvruTVKQSh4bgU1moePhe57U=";
  };
in
{
  # nixpkgs.overlays = [
  #   (self: super: {
  #     nvidia_x11 = super.nvidia_x11.overrideAttrs (oldAttrs: {
  #       latest = oldAttrs.latest.overrideAttrs (drvAttrs: {
  #         patches = drvAttrs.patches ++ [ drm_fop_flags_patch ];
  #       });
  #     });
  #   })
  # ];

	hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  
    modesetting.enable = true;
    nvidiaPersistenced = true;

    # enable if issues with sleep
    powerManagement.enable = true;
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

  boot = {
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    kernelParams = [ "nvidia-drm.fbdev=1" ];
  };
}
