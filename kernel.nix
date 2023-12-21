{ pkgs, ... }:
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
}
