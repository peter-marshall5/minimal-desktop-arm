{
  description = "Build NixOS images for veyron-speedy";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-appliance = {
      url = "github:peter-marshall5/nixos-appliance";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    u-boot.url = "github:peter-marshall5/u-boot-veyron-speedy";
  };

  outputs = { self, nixpkgs, nixos-appliance, u-boot, ... }: {

    nixosModules.cross-armv7 = {config, ...}: {
      nixpkgs.config.allowUnsupportedSystem = true;
      nixpkgs.hostPlatform.system = "armv7l-linux";
      nixpkgs.buildPlatform.system = "x86_64-linux";
    };

    nixosModules.kernel = import ./kernel.nix;
    
    nixosModules.bootConfig  = {config, pkgs, ...}: {
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
    };

    nixosModules.bootableImage = {config, pkgs, ...}: {
      imports = [
        self.nixosModules.kernel
        self.nixosModules.bootConfig
      ];
    };

    images.speedy = nixos-appliance.nixosGenerate {
      system = "armv7l-linux";
      modules = [
        ./configuration.nix
        ./kernel.nix
        self.nixosModules.bootableImage
      ];
    };

  };
}
