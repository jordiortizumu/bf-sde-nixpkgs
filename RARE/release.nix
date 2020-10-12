{ freerouter_src ? null }:

let
  pkgs = import ./. {};
  freerouter = pkgs.freerotuer;
  freerouter_latest = pkgs.freerouter.overrideAttrs (_: rec {
    version = "latest";
    name = "freerouter-${version}";
    src = freerouter_src;
  });
  ## Hydra doesn't like non-derivation attributes
  RARE = pkgs.lib.filterAttrs (n: v: n != "recurseForDerivations") pkgs.RARE;

in if freerouter_src == null then
  {
    inherit RARE;
  }
else
  {
    inherit freerouter freerouter_latest;
  }
