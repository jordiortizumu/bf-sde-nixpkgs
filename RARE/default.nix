{ overlays ? [], kernelID ? null, ... } @attrs:

import ../. (attrs // {
  overlays = overlays ++ import ./overlay.nix kernelID;
})
