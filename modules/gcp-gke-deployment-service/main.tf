provider "kubernetes" {
  token                         = var.access_token
  host                          = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate        = base64decode(var.ca_certificate)
}

locals {
  ssl_certificate   = "${var.cluster_name}-gke-managed-ssl-certificate"
}

# module "gcp-gke-deployment" {
#   source = "git::git@github.com:TopTierAuthentics/terraform.git//modules/gcp-gke-deployment" # ?ref=v0.0.1"
#
#   cluster_endpoint            = var.cluster_endpoint
#   cluster_name                = var.cluster_name
#   ca_certificate              = var.ca_certificate
#   access_token                = var.access_token
#   service_account_name        = var.service_account_name
#   env_name                    = var.env_name
#
#   name                        = "auth"
#   port                        = 3001
#
#   enable_postgresql            = false
#   postgresql_connection_port   = 5432
#   postgresql_connection_name   = var.connection_name
#   postgresql_database_user     = var.psql_user_name
#   postgresql_database_password = var.psql_user_pass
# }

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

resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = var.port
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = var.port
      target_port = var.port
    }

    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 3030
      target_port = 3030
    }

    type = var.type
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "autoscaler" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    target_cpu_utilization_percentage = 75

    scale_target_ref {
      kind = "Deployment"
      name = var.name
    }
  }
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "networking.gke.io/managed-certificates"      = local.ssl_certificate
      "ingress.gcp.kubernetes.io/pre-shared-cert"   = local.ssl_certificate
    }
  }

  spec {
    default_backend {
      service {
        name = var.name
        port {
          number = var.port
        }
      }
    }
  }
}

# resource "k8s_monitoring_coreos_com_pod_monitor_v1" "monitor" {
#   metadata = {
#     name = var.name
#   }
#   spec = {
#     pod_metrics_endpoints = [
#       {
#         path = "/metrics"
#         port = "metrics"
#       }
#     ]
#     selector = {
#       match_labels = {
#         "app" = var.name
#       }
#     }
#   }
# }

resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  name = local.ssl_certificate

  managed {
    domains = var.domains
  }
}
