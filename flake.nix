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
      [ flake-utils.lib.system.x86_64-linux ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ nur.overlay ]; };
        in
        {
          packages = rec {
            default = firefox;
            firefox =
              pkgs.wrapFirefox pkgs.firefox-unwrapped {
                nativeMessagingHosts = [ pkgs.nur.repos.wolfangaukang.vdhcoapp ];
              };
            vdhcoapp = pkgs.nur.repos.wolfangaukang.vdhcoapp;
          };
          apps = rec {
            firefox = flake-utils.lib.mkApp { drv = self.packages.${system}.firefox; };
            default = firefox;
          };
        });
}
