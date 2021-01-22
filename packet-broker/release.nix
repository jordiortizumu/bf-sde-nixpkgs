{ }:

with import ./. {};

let
  kernels = import ../bf-sde/kernels pkgs;
  broker = packetBroker.packetBroker;
  wrappers = lib.mapAttrs (kernelID: _: broker.makeModuleWrapperForKernel kernelID) kernels;
  packetBroker' = (with lib; filterAttrs (n: v: attrsets.isDerivation v) packetBroker);
in {
  packetBroker = packetBroker' // { inherit wrappers; };
  inherit SNMPAgent;
}
