resource "oci_load_balancer_load_balancer" "Load_Balancer" {
  compartment_id = var.compartment_ocid
  display_name = "portal-cloud-lb"
  shape          = "flexible"
  subnet_ids = [
    oci_core_subnet.public_subnet.id,
  ]
  shape_details {
      #Required
      maximum_bandwidth_in_mbps = var.load_balancer_max_band
      minimum_bandwidth_in_mbps = var.load_balancer_min_band
    }
}
# Certificado SSL (HTTPS)
resource "oci_load_balancer_certificate" "cert_https" {
  load_balancer_id = oci_load_balancer_load_balancer.Load_Balancer.id
  certificate_name = "cert-portal-cloud"

  public_certificate = file("${path.module}/certs/cert.pem")
  private_key        = file("${path.module}/certs/key.pem")

  passphrase = var.cert_passphrase
}
resource "oci_load_balancer_backend_set" web-servers-backend {
  health_checker {
    interval_ms         = "10000"
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ""
    retries             = "3"
    return_code         = "200"
    timeout_in_millis   = "3000"
    url_path            = "/"
  }
  load_balancer_id = oci_load_balancer_load_balancer.Load_Balancer.id
  name             = "web-servers-backend"
  policy           = "ROUND_ROBIN"
}
resource "oci_load_balancer_backend" vm1-portal-cloud-sp {
  backendset_name  = oci_load_balancer_backend_set.web-servers-backend.name
  backup           = "false"
  drain            = "false"
  load_balancer_id = oci_load_balancer_load_balancer.Load_Balancer.id
  ip_address       = oci_core_instance.web-01.private_ip
  offline          = "false"
  port             = "80"
  weight           = "1"
}
resource "oci_load_balancer_backend" vm2-portal-cloud-sp {
  backendset_name  = oci_load_balancer_backend_set.web-servers-backend.name
  backup           = "false"
  drain            = "false"
  load_balancer_id = oci_load_balancer_load_balancer.Load_Balancer.id
  ip_address       = oci_core_instance.web-02.private_ip
  offline          = "false"
  port             = "80"
  weight           = "1"
}
resource "oci_load_balancer_listener" lb-listeners {
  connection_configuration {
    backend_tcp_proxy_protocol_version = "0"
    idle_timeout_in_seconds            = "60"
  }
  default_backend_set_name = oci_load_balancer_backend_set.web-servers-backend.name
  hostname_names = [
  ]
  load_balancer_id = oci_load_balancer_load_balancer.Load_Balancer.id
  name             = "lb-listeners"
  port     = "443"
  protocol = "TCP"
  ssl_configuration {
    certificate_name = oci_load_balancer_certificate.cert_https.certificate_name
    verify_peer_certificate = false
    protocols = ["TLSv1.2"]
  }
  rule_set_names = [
  ]
}