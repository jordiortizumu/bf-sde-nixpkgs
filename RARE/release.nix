{ freerouter_src ? null }:

let
  pkgs = import ./. {};
in
with pkgs;
with lib;
let
  freerouter_latest = freerouter.overrideAttrs (_: rec {
    version = "latest";
    name = "freerouter-${version}";
    src = freerouter_src;
  });
  wrappable = filterAttrs (n: v: v ? "makeModuleWrapper") pkgs.RARE;
  kernels = import ../bf-sde/kernels pkgs;
  wrappersFor = program:
    let
      kernels = import ../bf-sde/kernels pkgs;
    in mapAttrs (kernelID: _: program.makeModuleWrapperForKernel kernelID) kernels;
  wrappers = mapAttrs' (name: program: (nameValuePair "${name}-wrappers"
                                       (wrappersFor program)))
                       wrappable;
  ## Hydra doesn't like non-derivation attributes
  RARE = (filterAttrs (n: v: attrsets.isDerivation v) pkgs.RARE) // wrappers;
in if freerouter_src == null then
  {
    inherit RARE freerouter SNMPAgent;
  }
else
  {
    inherit freerouter freerouter_latest;
  }
