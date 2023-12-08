{
  description = "firefox with vdhcoapp";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NUR repo
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, flake-utils, nixpkgs, nur, ... }@inputs:
    flake-utils.lib.eachSystem
      [ flake-utils.system.lib.x86_64-linux flake-utils.system.lib.aarch64-linux ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ nur.overlay ]; };
        in
        {
          packages = {
            default =
              pkgs.wrapFirefox pkgs.firefox-unwrapped {
                nativeMessagingHosts = [ pkgs.nur.repos.wolfangaukang.vdhcoapp ];
              };
            vdhcoapp = pkgs.nur.repos.wolfangaukang.vdhcoapp;
          };
        });
}
