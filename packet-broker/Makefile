.DEFAULT_GOAL = none

none:

install:
	nix-env -f . -p $${PB_PROFILE:-/nix/var/nix/profiles/per-user/$$USER/packet-broker} -i -A packetBroker -A SNMPAgent
