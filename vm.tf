resource "google_compute_address" "ip-aula" {
  name = "ip-aula"
}

resource "google_compute_address" "internal-ip" {
  name         = "internal-ip"
  project      = "teste-sample-388301" 
  subnetwork   = google_compute_subnetwork.subnet-aula.name
  address_type = "INTERNAL"
  address     = "10.80.4.11"
  region       = "us-central1"
}

resource "google_compute_instance" "vm-aula" {
  name         = "vm-aula"
  machine_type = "e2-small"

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc-aula.name
    subnetwork = google_compute_subnetwork.subnet-aula.name
    network_ip = google_compute_address.internal-ip.address
    
    access_config {
      nat_ip = google_compute_address.ip-aula.address
    }
  }
  tags = ["allow-ssh"]
}

resource "null_resource" "upload" {
  triggers = {
    order = google_compute_instance.vm-aula.id
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = google_compute_address.ip-aula.address
    }

    source      = "springapp"
    destination = "/home/ubuntu"
  }
}

resource "null_resource" "deploy" {
  triggers = {
    order = null_resource.upload.id
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = google_compute_address.ip-aula.address
    }

    inline = [
      "chmod 777 /home/ubuntu/springapp/install.sh",
      "cd /home/ubuntu/springapp/ && ./install.sh"
    ]
  }
}
