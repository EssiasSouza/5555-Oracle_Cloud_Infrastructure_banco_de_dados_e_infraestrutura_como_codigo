# Data from terraform.tfvars file

variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

# Choose an Availability Domain
variable "AD" {
  default = "1"
}

# VCN variables
variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS label"
  default     = "vcn1"
}

# OS Image

variable "image_operating_system" {
  default = "Canonical Ubuntu"
}

variable "image_operating_system_version" {
  default = "24.04"
}

### Compute Shape

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E2.1.Micro"
}

# Load Balancer Shape

variable "load_balancer_min_band" {
  description = "Load Balancer Max Band"
  default     = "10"
}

variable "load_balancer_max_band" {
  description = "Load Balancer Max Band"
  default     = "10"
}

####################################
# Load Balancer
####################################

variable "cert_passphrase" {
  description = "Senha do certificado SSL (se existir, deixe vazio se não tiver)"
  type        = string
  sensitive   = true
}