{ freerouter ? null }:

with import ./.;
let
  freerouter_latest = freerouter.overrideAttrs (_: rec {
    version = "latest";
    name = "freerouter-${version}";
    src = freerouter;
  });
in if freerouter == null then
  {
    inherit RARE;
  }
else
  {
    inherit freerouter freerouter_latest;
  }
