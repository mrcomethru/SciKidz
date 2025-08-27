{
  description = "Empty flake with basic devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };

      androidSdk = pkgs.androidenv.androidPkgs.androidsdk;
    in {
      formatter = pkgs.alejandra;

      devShells = with pkgs; {
        default = mkShell {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

          buildInputs = [
            flutter
            androidSdk
            jdk17
          ];
        };
      };
    });
}
