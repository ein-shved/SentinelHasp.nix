{
  description = "Ascon Sentinel HASP authentication server";

  inputs = {
    nixpkgs.url = "nixpkgs";
    aksusbd_vlib.url = "https://sd7.ascon.ru/Public/Utils/Sentinel%20HASP/Linux_driver/aksusbd_vlib46707.tar";
    aksusbd_vlib.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, aksusbd_vlib, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          aksusbd = pkgs.callPackage ./. { inherit aksusbd_vlib system; };
          default = aksusbd;
          module = { config, ... } : {
            config.nixpkgs.overlays = [ (self: super: { inherit aksusbd; }) ];
            imports = [ ./module.nix ];
          };
        };
      }
    );
}
