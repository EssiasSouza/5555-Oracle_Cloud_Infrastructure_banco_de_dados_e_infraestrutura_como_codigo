# Compute Instances
data "template_file" "user_data" {
  template = file("cloud-init.yaml")
}

resource "oci_core_instance" "web-01" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD -1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "vm1"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet.id
    display_name = "vm1-vnic"
  }
  source_details {
    source_type             = "image"
    source_id               = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(data.template_file.user_data.rendered)
  }

}

resource "oci_core_instance" "web-02" {
   availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD -1]["name"]
   compartment_id      = var.compartment_ocid
   display_name        = "vm2"
   shape               = var.instance_shape
 
   create_vnic_details {
     subnet_id = oci_core_subnet.subnet.id
     display_name = "vm2-vnic"
   }
   source_details {
     source_type             = "image"
     source_id               = lookup(data.oci_core_images.compute_images.images[0], "id")
     boot_volume_size_in_gbs = "50"
   }
 
   metadata = {
     ssh_authorized_keys = var.ssh_public_key
     user_data = base64encode(data.template_file.user_data.rendered)
   }
 
 }
