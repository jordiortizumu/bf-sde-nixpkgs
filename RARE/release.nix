{ freerouter_src ? null }:

with import ./. {};
let
  freerouter_latest = freerouter.overrideAttrs (_: rec {
    version = "latest";
    name = "freerouter-${version}";
    src = freerouter_src;
  });
in if freerouter_src == null then
  {
    inherit RARE;
  }
else
  {
    inherit freerouter freerouter_latest;
  }
