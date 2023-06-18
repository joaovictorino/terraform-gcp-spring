resource "google_compute_address" "ip-aula-db" {
  name = "ip-aula-db"
}

resource "google_compute_address" "internal-ip-db" {
  name         = "internal-ip-db"
  project      = "teste-sample-388301"
  subnetwork   = google_compute_subnetwork.subnet-aula.name
  address_type = "INTERNAL"
  address      = "10.80.4.10"
  region       = "us-central1"
}

resource "google_compute_instance" "vm-aula-db" {
  name         = "vm-aula-db"
  machine_type = "e2-small"

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-pro-cloud/ubuntu-pro-1804-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc-aula.name
    subnetwork = google_compute_subnetwork.subnet-aula.name
    network_ip = google_compute_address.internal-ip-db.address

    access_config {
      nat_ip = google_compute_address.ip-aula-db.address
    }
  }
  tags = ["allow-ssh"]
}

resource "null_resource" "upload_db" {
  triggers = {
    order = google_compute_instance.vm-aula-db.id
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = google_compute_address.ip-aula-db.address
    }

    source      = "mysql"
    destination = "/home/ubuntu"
  }
}

resource "null_resource" "deploy_db" {
  triggers = {
    order = null_resource.upload_db.id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = google_compute_address.ip-aula-db.address
    }

    inline = [
      "chmod 777 ./mysql/install.sh",
      "./mysql/install.sh"
    ]
  }
}
