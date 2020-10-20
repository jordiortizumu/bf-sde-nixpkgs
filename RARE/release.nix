{ freerouter_src ? null }:

let
  pkgs = import ./. {};
  freerouter = pkgs.freerouter;
  freerouter_latest = pkgs.freerouter.overrideAttrs (_: rec {
    version = "latest";
    name = "freerouter-${version}";
    src = freerouter_src;
  });
  ## Hydra doesn't like non-derivation attributes
  RARE = with pkgs.lib; filterAttrs (n: v: attrsets.isDerivation v) pkgs.RARE;

in if freerouter_src == null then
  {
    inherit RARE freerouter SNMPAgent;
  }
else
  {
    inherit freerouter freerouter_latest;
  }
