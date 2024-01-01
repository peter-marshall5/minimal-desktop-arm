{ config, pkgs, u-boot, ... }:
{
  boot.kernelPackages = pkgs.linuxPackagesFor (let
    baseKernel = pkgs.linux_latest;
  in
  pkgs.linuxManualConfig {
    inherit (baseKernel) src modDirVersion;
    version = "${baseKernel.version}-veyron-speedy";
    configfile = ./speedy_kernel_config;
    allowImportFromDerivation = true;
  });
  
  boot.kernelPatches = [{
    name = "veyron-fixes";
    patch = ./veyron-fixes.patch;
  }];

  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];

  boot.kernelParams = [ "console=ttyS0,115200" "console=tty0" ];

  boot.loader.depthcharge = {
    enable = true;
    kernelPart = "${u-boot.bin.speedy-kpart}";
  };

  hardware.deviceTree = {
    enable = true;
    name = "rk3288-veyron-speedy.dtb";
  };
}
