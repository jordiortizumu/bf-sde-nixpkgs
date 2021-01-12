include ../Makefile

install:
	nix-env -f . -p $${PB_PROFILE:-/nix/var/nix/profiles/per-user/$$USER/packet-broker} -r -i \
	  -A packetBroker.packetBroker -A packetBroker.configd \
	  -A packetBroker.packetBroker.makeModuleWrapper \
	  -A packetBroker.bf-sde.pkgs.bf-utils \
	  -A SNMPAgent
