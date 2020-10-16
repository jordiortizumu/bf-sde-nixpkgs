{ overlays ? [], ... } @attrs:

import ../. (attrs // {
  overlays = overlays ++ import ./overlay.nix;
})
