include ../Makefile

install:
	nix-env -f . -p $${RARE_PROFILE:-/nix/var/nix/profiles/per-user/$$USER/RARE} -r -i \
		-A RARE.mpls \
		-A RARE.mpls.makeModuleWrapper \
		-A RARE.mpls_wedge100bf32x \
		-A RARE.mpls_wedge100bf32x.makeModuleWrapper \
		-A RARE.srv6 \
		-A RARE.srv6.makeModuleWrapper \
		-A RARE.srv6_wedge100bf32x \
		-A RARE.srv6_wedge100bf32x.makeModuleWrapper \
		-A RARE.p4Dummy.makeModuleWrapper \
		-A RARE.bf-sde.pkgs.bf-utils \
		-A freerouter -A SNMPAgent

