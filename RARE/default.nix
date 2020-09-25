{ ... } @args:

import ../nixpkgs (args // {
  overlays =
    import ../overlay.nix ++
    import ./overlay.nix;
})
