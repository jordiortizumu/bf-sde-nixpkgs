include ../Makefile

install:
	nix-env -f . -p $${PB_PROFILE:-/nix/var/nix/profiles/per-user/$$USER/packet-broker} -r -i \
	  -A packetBroker.packetBroker.makeModuleWrapper \
	  -A packetBroker.configd \
	  -A packetBroker.bf-sde.pkgs.bf-utils \
	  -A packetBroker.services \
	  -A SNMPAgent
