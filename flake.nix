{
  description = "Niri-dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      vars = import ./vars.nix;
      pkgs = nixpkgs.legacyPackages.${system};
      in {
        homeConfigurations."USER@HOST" = home-manager.lib.homeManagerConfiguration {
	  inherit pkgs;
	  modules = [
	    ./modules/system/configuration.nix
	  ];
	};
	formatter.${system} = pkgs.nixfmt-rfc-style;
      };
}
