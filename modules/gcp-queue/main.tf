provider "kubernetes" {
  token                  = var.access_token
  host                   = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate = base64decode(var.ca_certificate)
}

resource "kubernetes_deployment" "queue" {
  metadata {
    name = "queue"
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "queue"
      }
    }

    template {
      metadata {
        labels = {
          app = "queue"
          run = "queue"
          namespace = "default"
        }
      }

      spec {
        container {
          name  = "queue"
          image = "us-central1-docker.pkg.dev/toptierauthentics/cloud-run-source-deploy/queue:latest"
          # args  = ["--requirepass", "topsecret"]

          env {
            name  = "NODEID"
            value = "queueNode"
          }

          env {
            name  = "PORT"
            value = "3005"
          }

          env {
            name  = "SERVICEDIR"
            value = "app/dist/src/services/queue"
          }

          env_from {
            config_map_ref {
              name = var.env_name
            }
          }

          port {
            container_port = 3005
          }
        }


        container {
          name  = "cloud-sql-proxy"
          image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.1.0"
          args = [
            "--structured-logs",
            "--port=${var.postgresql_connection_port}",
            "${var.postgresql_connection_name}"
          ]
        }

        service_account_name  = var.service_account_name
        restart_policy        = "Always" # var.restart_policy
        hostname              = "queue" # var.name
        # restart_policy = "Always"
        # hostname       = "queue"
      }
    }
  }
}

resource "kubernetes_service" "queue" {
  metadata {
    name = "queue"
    namespace = "default"

    labels = {
      app = "queue"
    }
  }

  spec {

    port {
      name        = "3005"
      port        = "3005"
      target_port = "3005"
    }

    selector = {
	    app = "queue"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "autoscaler" {
  metadata {
    name = "queue"
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    target_cpu_utilization_percentage = 75

    scale_target_ref {
      kind = "Deployment"
      name = "queue"
    }
  }
}

