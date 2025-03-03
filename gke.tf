# resource "google_container_node_pool" "example_node_pool" {
#   name               = "example-node-pool-1"
#   cluster            = "example-cluster-1"
#   project            = var.PROJECT_ID
#   initial_node_count = 1

#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"
#   }
# }
