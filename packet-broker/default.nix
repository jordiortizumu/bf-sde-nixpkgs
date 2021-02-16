{ overlays ? [], ... } @attrs:

import ../. (attrs // {
  overlays = import ./overlay.nix ++ overlays;
})
