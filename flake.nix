{
  description = "Support package for veyron-speedy hardware";

  inputs = {
    u-boot.url = "github:peter-marshall5/u-boot-veyron-speedy";
  };

  outputs = { self, u-boot, ... }: {

    nixosModules.cross-armv7 = {config, nixpkgs, ...}: {
      nixpkgs.config.allowUnsupportedSystem = true;
      nixpkgs.hostPlatform.system = "armv7l-linux";
      nixpkgs.buildPlatform.system = "x86_64-linux";
    };

    nixosModules.veyron-speedy = import ./veyron-speedy.nix u-boot;

  };
}
