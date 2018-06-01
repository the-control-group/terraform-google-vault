resource "google_storage_bucket" "vault-storage" {
  name          = "${var.cluster_name}"
  location      = "US"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket_acl" "vault-storage-acl" {
  bucket         = "${google_storage_bucket.vault-storage.name}"
  predefined_acl = "projectPrivate"
}

resource "google_compute_instance_template" "vault-group-template" {
  name_prefix  = "${var.cluster_name}"
  machine_type = "${var.machine_type}"
  tags         = ["${var.cluster_tag}"]

  labels = {
    group = "${var.cluster_tag}"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "${var.source_image}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = "${var.subnet}"

    # TESTING ONLY!!!! Needs to be remove.
    # Assigns public IP address.
    access_config {}
  }

  service_account {
    scopes = "${var.scopes}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "vault-group-manager" {
  name               = "${var.cluster_name}-group-manager"
  region             = "${var.region}"
  base_instance_name = "${var.cluster_name}"
  instance_template  = "${google_compute_instance_template.vault-group-template.self_link}"
  target_size        = "${var.cluster_size}"
  update_strategy    = "ROLLING_UPDATE"

  rolling_update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_unavailable_fixed = 1
    min_ready_sec         = 50
  }
}

resource "google_compute_firewall" "vault-cluster-communication" {
  name    = "${var.cluster_name}-cluster-communication"
  network = "${var.network}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.cluster_port}",
    ]
  }

  source_tags = ["${var.cluster_tag}"]
  target_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "vault-client-communication" {
  name    = "${var.cluster_name}-client-communication"
  network = "${var.network}"

  allow {
    protocol = "tcp"

    ports = [
      "${var.http_port}",
    ]
  }

  source_tags = ["${var.client_tag}"]
  target_tags = ["${var.cluster_tag}"]
}

resource "google_compute_firewall" "vault-exporter-communication" {
  name    = "${var.cluster_name}-prometheus-communication"
  network = "${var.network}"

  allow {
    protocol = "tcp"

    ports = [
      "9410",
    ]
  }

  source_tags = ["${var.prometheus_server_tag}"]
  target_tags = ["${var.cluster_tag}"]
}
