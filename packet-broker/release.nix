{ }:

with import ./. {};
with packet-broker;

## Have the CI build the data-plane and control-plane programs as well
## as the closure for binary deployments.
release // {
  inherit closure;
}
