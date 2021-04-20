resource "random_id" "server_node_id" {
  byte_length = 2
  count       = var.server_count
}

resource "random_id" "agent_node_id" {
  byte_length = 2
  count       = var.agent_count
}
