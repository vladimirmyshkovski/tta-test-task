provider "kubernetes" {
  token                  = var.access_token
  host                   = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate = base64decode(var.ca_certificate)
}

resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
          run = "redis"
          namespace = "default"
        }
      }

      spec {
        container {
          name  = "tta-redis"
          image = "redis:alpine"
          args  = ["--requirepass", "topsecret"]

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

          port {
            container_port = 6379
          }
        }
        restart_policy = "Always"
        hostname       = "redis"
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
    namespace = "default"

    labels = {
      app = "redis"
    }
  }

  spec {
    port {
      name        = "6379"
      port        = "6379"
      target_port = "6379"
    }

    selector = {
	    app = "redis"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "autoscaler" {
  metadata {
    name = "redis"
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
