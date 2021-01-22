include ../Makefile

install:
	nix-env -f . -p $${RARE_PROFILE:-/nix/var/nix/profiles/per-user/$$USER/RARE} -r -i -A RARE.install

