{
  description = "Support package for veyron-speedy hardware";

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

    nixosModules.veyron-speedy = import ./veyron-speedy.nix;

    images.speedy = nixos-appliance.nixosGenerate {
      system = "armv7l-linux";
      modules = [
        ./configuration.nix
        self.nixosModules.cross-armv7
        self.nixosModules.veyron-speedy
      ];
    };

  };
}
