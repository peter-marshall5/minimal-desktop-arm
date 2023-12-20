{
  description = "Build NixOS images for veyron-speedy";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-appliance = {
      url = "github:peter-marshall5/nixos-appliance";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-appliance, ... }: {

    nixosModules.cross-armv7 = {config, ...}: {
      nixpkgs.config.allowUnsupportedSystem = true;
      nixpkgs.hostPlatform.system = "armv7l-linux";
      nixpkgs.buildPlatform.system = "x86_64-linux";
    };

    images.speedy = nixos-appliance.nixosGenerate {
      system = "armv7l-linux";
      modules = [
        ./configuration.nix
        self.nixosModules.cross-armv7
      ];
    };

  };
}
