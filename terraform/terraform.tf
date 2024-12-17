
terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "1.0"
    }
  }
}

provider "opennebula" {
  endpoint      = "${var.one_endpoint}"
  username      = "${var.one_username}"
  password      = "${var.one_password}"
}

resource "opennebula_virtual_machine" "loadBalancer-node" {
  name = "loadBalancer-node"
  description = "LoadBalancer node VM"
  cpu = 1
  vcpu = 1
  memory = 2048
  permissions = "600"
  group = "users"

  context = {
    NETWORK  = "YES"
    HOSTNAME = "$NAME"
    SSH_PUBLIC_KEY = "${var.vm_ssh_pubkey}"
  }
  os {
    arch = "x86_64"
    boot = "disk0"
  }
  disk {
    #image_id = opennebula_image.os-image.id
    image_id = 687
    target   = "vda"
    size     = 12000 # 12GB
  }

  graphics {
    listen = "0.0.0.0"
    type   = "vnc"
  }

  nic {
    network_id = var.vm_network_id
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${self.ip}"
    private_key = "${file("/var/iac-dev-container-data/id_ecdsa")}"
  }

  tags = {
    role = "loadBalancer"
  }
 
}

resource "opennebula_virtual_machine" "backend-node" {
  count = var.backend_nodes_count
  name = "backend-node-${count.index + 1}"
  description = "Backend node VM #${count.index + 1}"
  cpu = 1
  vcpu = 1
  memory = 1024
  permissions = "600"
  group = "users"

  context = {
    NETWORK  = "YES"
    HOSTNAME = "$NAME"
    SSH_PUBLIC_KEY = "${var.vm_ssh_pubkey}"
  }
  os {
    arch = "x86_64"
    boot = "disk0"
  }
  disk {
    #image_id = opennebula_image.os-image.id
    image_id = 687
    target   = "vda"
    size     = 12000 # 12GB
  }

  graphics {
    listen = "0.0.0.0"
    type   = "vnc"
  }

  nic {
    network_id = var.vm_network_id
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${self.ip}"
    private_key = "${file("/var/iac-dev-container-data/id_ecdsa")}"
  }

  tags = {
    role = "backend"
  } 


}

#-------OUTPUTS ------------

output "loadBalancer_node" {
  value = "${opennebula_virtual_machine.loadBalancer-node.*.ip}"
}

output "backend_nodes" {
  value = "${opennebula_virtual_machine.backend-node.*.ip}"
}

resource "local_file" "hosts_cfg" {
  content = templatefile("../ansible/inventory.tmpl",
    {
      vm_admin_user = var.vm_admin_user,
      loadBalancer_node = opennebula_virtual_machine.loadBalancer-node.*.ip,
      backend_nodes = opennebula_virtual_machine.backend-node.*.ip
    })
  filename = "./dynamic_inventories/cluster"
} 

#
# EOF
#
