{ lib, bf-sde, fetchgit, flavor, buildFlags, requiredKernelModule }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  flavorStr = sep:
    lib.optionalString (flavor != null) "${sep}${flavor}";
in bf-sde.buildP4Program rec {
  inherit (repo) version src;
  pname = "RARE${flavorStr "-"}";
  p4Name = "bf_router";
  path = "p4src";
  execName = "bf_router${flavorStr "_"}";
  inherit buildFlags requiredKernelModule;
}
