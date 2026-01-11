########################################
# VCN
########################################
resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr

  # dns_label precisa ser curto, minúsculo e sem hífen
  dns_label    = var.vcn_dns_label
  display_name = var.vcn_dns_label
}

########################################
# Internet Gateway (necessário só para subnet pública)
########################################
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}

########################################
# Route Table Pública (com acesso à internet)
########################################
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

########################################
# Route Table Privada (SEM Internet Gateway)
########################################
resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}-private-rt"

  # Sem rota 0.0.0.0/0 → subnet privada não acessa internet
}

########################################
# Security List - Subnet Pública
########################################
resource "oci_core_security_list" "sl_public" {
  display_name   = "SL_public"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id

  # Saída liberada
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  # HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }

  # SSH (ideal depois restringir para seu IP)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
}

########################################
# Security List - Subnet Privada
########################################
resource "oci_core_security_list" "sl_private" {
  display_name   = "SL_private"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id

  # Saída liberada (pode restringir depois)
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  # HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }
  # MySQL somente vindo da subnet pública
  ingress_security_rules {
    protocol = "6"
    source   = cidrsubnet(var.vcn_cidr, 8, 1)

    tcp_options {
      min = 3306
      max = 3306
    }
  }
}

########################################
# Subnet Pública
########################################
resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id

  # Ex: 10.0.1.0/24
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 1)

  display_name = "public-subnet"
  dns_label    = "public"

  route_table_id    = oci_core_route_table.public_rt.id
  security_list_ids = [oci_core_security_list.sl_public.id]
  prohibit_public_ip_on_vnic = false
}

########################################
# Subnet Privada
########################################
resource "oci_core_subnet" "private_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id

  # Ex: 10.0.2.0/24
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 2)

  display_name = "private-subnet"
  dns_label    = "private"

  route_table_id    = oci_core_route_table.private_rt.id
  security_list_ids = [oci_core_security_list.sl_private.id]

  # Garante que nenhuma VM tenha IP público
  prohibit_public_ip_on_vnic = true
}
