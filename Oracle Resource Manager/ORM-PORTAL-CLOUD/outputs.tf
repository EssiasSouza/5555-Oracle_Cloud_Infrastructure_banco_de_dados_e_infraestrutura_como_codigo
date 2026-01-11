output "Load_Balancer_Public_IP" {
  value = oci_load_balancer_load_balancer.Load_Balancer.ip_address_details[0].ip_address
}