resource "kubernetes_namespace" "app" {
  metadata {
    name = "${var.project_name}-${var.environment}"
    labels = local.common_labels
  }
}

# ConfigMap for application configuration
resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${var.project_name}-config"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  data = {
    app_name     = var.project_name
    environment  = var.environment
    s3_bucket    = aws_s3_bucket.app_bucket.bucket
    dynamodb_table = aws_dynamodb_table.app_table.name
    sqs_queue_url  = aws_sqs_queue.app_queue.url
    app_version    = "1.0.0"
    debug_mode     = "true"
    max_connections = "100"
    log_level      = "info"
  }
}

# Secret for AWS credentials (even though we're using LocalStack)
resource "kubernetes_secret" "aws_credentials" {
  metadata {
    name      = "${var.project_name}-aws-creds"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  data = {
    aws_access_key_id     = base64encode("test")
    aws_secret_access_key = base64encode("test")
    aws_region           = base64encode(var.aws_region)
    aws_endpoint_url     = base64encode("http://host.docker.internal:4566")
  }

  type = "Opaque"
}

# Deployment for our demo application
resource "kubernetes_deployment" "app" {
  metadata {
    name      = "${var.project_name}-app"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "${var.project_name}-app"
      }
    }

    template {
      metadata {
        labels = merge(local.common_labels, {
          app = "${var.project_name}-app"
        })
      }

      spec {
        container {
          image = "nginx:alpine"
          name  = "app"

          port {
            container_port = 80
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.aws_credentials.metadata[0].name
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

# Service to expose the application
resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.project_name}-service"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    selector = {
      app = "${var.project_name}-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "app_hpa" {
  metadata {
    name      = "${var.project_name}-hpa"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    min_replicas = 2
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}

# Ingress for external access
resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "${var.project_name}-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "my-local-app.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.app.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# # PersistentVolumeClaim for storage
# resource "kubernetes_persistent_volume_claim" "app_storage" {
#   metadata {
#     name      = "${var.project_name}-storage"
#     namespace = kubernetes_namespace.app.metadata[0].name
#     labels    = local.common_labels
#   }

#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#   }
# }

# Job for one-time tasks
resource "kubernetes_job_v1" "database_migration" {
  metadata {
    name      = "${var.project_name}-db-migration"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    template {
      metadata {
        labels = local.common_labels
      }
      spec {
        container {
          name    = "migration"
          image   = "busybox"
          command = ["sh", "-c", "echo 'Running database migration...' && sleep 10 && echo 'Migration complete!'"]
        }
        restart_policy = "Never"
      }
    }
  }
}