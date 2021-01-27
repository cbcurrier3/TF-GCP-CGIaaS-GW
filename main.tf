// Terraform Main file
// v2.0 9/19/2020
// To launch with Terraform on GCP a Check Point R80.40 Cloudguard Instance 
// By CB Currier <ccurrier@checkpoint.com>

provider "google" {
  credentials	= file("terraform-admin.json")
  project 	= var.project
  region  	= var.proj_region
}

// Create default
resource "google_compute_network" "default" {
 name                    = "default"
}

// Create VPC1
resource "google_compute_network" "chkp-vpc1" {
 name                    = "chkp-vpc1"
 auto_create_subnetworks = "false"
}

// Create VPC1-Subnet1
resource "google_compute_subnetwork" "chkp-vpc1-subnet" {
 name          = "chkp-vpc1-subnet"
 ip_cidr_range = "10.0.0.0/24"
 network       = google_compute_network.chkp-vpc1.name
 region      = var.proj_region
}

data "template_file" "config_tpl" {
  template = file("${path.cwd}/config.tpl")
  vars = {
    gwname = var.gwname
    sickey = var.sickey
  }
}

data "google_compute_image" "cpgateway" {
  name    = "${var.templName}-${var.templVer}"
  project = "checkpoint-public"
}

resource "google_compute_instance" "default" {
  name           = var.gwname
  machine_type   = var.machinetype
  zone           = var.proj_zone
  can_ip_forward = var.canipfwd
 
   boot_disk {
    initialize_params {
      image = data.google_compute_image.cpgateway.self_link
    }
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.chkp-vpc1-subnet.self_link
    access_config {}
  }
  metadata = {
    adminPasswordSourceMetadata = var.adminpwd
    enable-oslogin = "true"
    sshKeys = "admin:${file(var.ssh_pub_key_file)}"
    additionalNetwork1 = "netw2"
    additionalSubnetwork1 = "net2sub1"
    allowUploadDownload = var.genpasswd
    cloudguardVersion = "R80.40-GW"
    computed_sic_key = var.sickey
    config_path = "projects/${var.project}/configs/${var.gwname}-config"
    config_url = "https://runtimeconfig.googleapis.com/v1beta1/projects/${var.project}/configs/${var.gwname}-config"
    deployment_config = "${var.gwname}-config"
    enableMonitoring = "${var.enablMon}"
    externalIP = "Static"
    externalIP1 = "Static"
    gatewayNetwork = "0.0.0.0/0"
    generatePassword = var.genpasswd
    hasInternet = "true"
    installationType = "${var.Ginstype["${var.instPref}"]}"
    machineType = var.machinetype
    managementGUIClientNetwork = "0.0.0.0/0"
    numAdditionalNICs = "1"
    shell = "/etc/cli.sh"
    sicKey = var.sickey
    templateName = var.templName
    templateVersion = var.templVer
  }
//  metadata_startup_script = data.template_file.gcp_tpl.rendered

  depends_on = [google_compute_firewall.test-firewall,
    google_compute_network.default,
    google_compute_network.chkp-vpc1,
  ]

  service_account {
    email  = var.svc_accnt_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/source.full_control", "https://www.googleapis.com/auth/cloudruntimeconfig" ]
  }
  provisioner "local-exec" {
   command = "sleep 120; sshpass -p 'admin' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} 'set user admin shell /bin/bash'"
  }
  provisioner "local-exec" {
   command = "sshpass -p 'admin' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} 'echo ${data.template_file.config_tpl.rendered} > /home/admin/ftwstart'"
  } 
  provisioner "local-exec" {
    command = "sshpass -p 'admin' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} 'chmod 755 /home/admin/ftwstart;nohup /bin/bash /home/admin/ftwstart'"
  }
}

resource "google_compute_firewall" "test-firewall" {
   name    = "test-firewall"
   network = google_compute_network.default.name

   allow {
     protocol = "icmp"
   }
   allow {
     protocol = "tcp"
   }
   allow {
     protocol = "icmp"
   }
   allow {
     protocol = "udp"
   }
   allow {
     protocol = "sctp"
   }
   allow {
     protocol = "esp"
   }

   source_ranges = ["0.0.0.0/0"] 
}


// Output
output "gw-public-default-ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip 
}
