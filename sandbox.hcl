# -----------------------------------------------------------------------------
# Shared infrastructure owned by the lab itself.
#
# The network lives here, not in a module, because several modules attach to
# it. Its ID is passed into each module as the network_id input.
#
#   10.0.200.10  lb     (load-balancer module)
#   10.0.200.11  blue   (web-app module, block "blue")
#   10.0.200.12  green  (web-app module, block "green")
# -----------------------------------------------------------------------------

resource "network" "main" {
  subnet = "10.0.200.0/24"
}
