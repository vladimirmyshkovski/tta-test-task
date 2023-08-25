provider "kubernetes" {
  token                       = var.access_token
  host                        = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate      = base64decode(var.ca_certificate)
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = {
      name = var.name
      run = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
          run = var.name
          namespace = var.namespace
        }
      }

      spec {
        container {
          name = "tta-${var.name}"
          image = "${var.image_path}/${var.name}:${var.image_tag}"

          port {
            container_port = var.port
          }

          env {
            name  = "NODEID"
            value = "${var.name}Node"
          }

          env {
            name  = "PORT"
            value = "${var.port}"
          }

          env {
            name = "POSTGRES_URI"
            value = "postgresql://${var.postgresql_database_user}:${var.postgresql_database_password}@127.0.0.1:${var.postgresql_connection_port}/postgres?schema=food"
          }

          env {
            name  = "SERVICEDIR"
            value = "/app/dist/src/services/${var.name}"
          }

          env_from {
            config_map_ref {
              name = var.env_name
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe_enabled ? [var.liveness_probe_enabled] : []

            content {
              http_get {
                path = var.liveness_probe_http_get_path
                port = var.port
              }

              initial_delay_seconds = var.liveness_probe_initial_delay_seconds
              timeout_seconds       = var.liveness_probe_timeout_seconds
              period_seconds        = var.liveness_probe_period_seconds
              failure_threshold     = var.liveness_probe_failure_threshold
              success_threshold     = var.liveness_probe_success_threshold
            }
          }

          dynamic "readiness_probe" {
            for_each = var.readiness_probe_enabled ? [var.readiness_probe_enabled] : []

            content {
              http_get {
                path = var.readiness_probe_http_get_path
                port = var.port
              }

              initial_delay_seconds = var.readiness_probe_initial_delay_seconds
              timeout_seconds       = var.readiness_probe_timeout_seconds
              period_seconds        = var.readiness_probe_period_seconds
              failure_threshold     = var.readiness_probe_failure_threshold
              success_threshold     = var.readiness_probe_success_threshold
            }
          }

          dynamic "startup_probe" {
            for_each = var.startup_probe_enabled ? [var.startup_probe_enabled] : []

            content {
              http_get {
                path = var.startup_probe_http_get_path
                port = var.port
              }

              initial_delay_seconds = var.startup_probe_initial_delay_seconds
              timeout_seconds       = var.startup_probe_timeout_seconds
              period_seconds        = var.startup_probe_period_seconds
              failure_threshold     = var.startup_probe_failure_threshold
              success_threshold     = var.startup_probe_success_threshold
            }
          }
          # resources {
          #   requests = {
          #     cpu = var.resources_requests_cpu
          #     memory = var.resources_requests_memory
          #   }

          #   limits = {
          #     cpu = var.resources_limits_cpu
          #     memory = var.resources_limits_memory
          #   }
          # }

          image_pull_policy = var.image_pull_policy
        }

        dynamic "container" {
          for_each = var.enable_postgresql ? [var.enable_postgresql] : []

          content {
            name  = "cloud-sql-proxy"
            image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.1.0"
            args = [
              "--structured-logs",
              "--port=${var.postgresql_connection_port}",
              "${var.postgresql_connection_name}"
            ]

            resources {
              requests = {
                cpu = "50m"
                memory = "64Mi"
              }

              limits = {
                cpu = "250m"
                memory = "256Mi"
              }
            }

            image_pull_policy = "IfNotPresent"
          }
        }
        service_account_name  = var.service_account_name
        restart_policy        = var.restart_policy
        hostname              = var.name
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "autoscaler" {
  metadata {
    name = var.name
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    target_cpu_utilization_percentage = var.target_cpu_utilization_percentage

    scale_target_ref {
      kind = "Deployment"
      name = var.name
    }
  }
}
