{ lib, bf-sde, fetchgit, flavor, buildFlags, kernelModule }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  flavorStr = sep:
    lib.optionalString (flavor != null) "${sep}${flavor}";
in bf-sde.buildP4Program rec {
  inherit (repo) version src;
  name = "RARE${flavorStr "-"}-${version}";
  p4Name = "bf_router";
  path = "p4src";
  execName = "bf_router${flavorStr "_"}";
  inherit buildFlags kernelModule;
}
