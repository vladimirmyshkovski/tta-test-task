provider "kubernetes" {
  token                  = var.access_token
  host                   = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate = base64decode(var.ca_certificate)
}

resource "kubernetes_deployment" "nats" {
  metadata {
    name = "nats"

    annotations = {
      nane = "nats"
      run  = "nats"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nats"
      }
    }

    template {
      metadata {
        labels = {
          app = "nats"
          run = "nats"
          namespace = "default"
        }
      }

      spec {
        volume {
          name = "nats"
          persistent_volume_claim {
            claim_name = "nats"
          }
        }

        volume {
          name = "nats-conf"
          config_map {
            name = "nats-conf"
          }
        }

        container {
          name  = "tta-nats"
          image = "nats:2.7.4-alpine"

          volume_mount {
            mount_path = "/etc/nats"
            name = "nats-conf"
            read_only = true
          }

          args = [
            "-c",
            "/etc/nats/nats.conf"
          ]

          resources {
            limits = {
              cpu = "250m"
              memory = "256Mi"
            }

            requests = {
              cpu = "50m"
              memory = "64Mi"
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "Always"
        hostname       = "nats"
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_service" "nats" {
  metadata {
    name = "nats"
    namespace = "default"

    labels = {
      app = "nats"
    }
  }

  spec {
    port {
      name        = "client"
      protocol    = "TCP"
      port        = "4222"
      target_port = "4222"
    }

    port {
      name        = "monitoring"
      protocol    = "TCP"
      port        = "8222"
      target_port = "8222"
    }

    selector = {
      app = "nats"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nats" {
  metadata {
    name = "nats"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "autoscaler" {
  metadata {
    name = "nats"
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    target_cpu_utilization_percentage = 75

    scale_target_ref {
      kind = "Deployment"
      name = "redis"
    }
  }
}

resource "kubernetes_config_map" "default" {
  metadata {
    name = "nats-conf"
  }

  data = {
    "nats.conf" = <<-EOT
      debug: true
      trace: false
      max_payload: 64MB
      max_pending: 64MB
      max_subscriptions: 100
    EOT
  }
}

