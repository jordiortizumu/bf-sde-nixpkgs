{ }:

with import ./. {};

{
  packetBroker = with lib; filterAttrs (n: v: attrsets.isDerivation v) packetBroker;
  inherit SNMPAgent;
}
