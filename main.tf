resource "null_resource" "create_kind_cluster" {
  provisioner "local-exec" {
    command = <<EOT
if ! kind get clusters | grep -q terraform-cluster; then
  cat <<EOF | kind create cluster --name terraform-cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
EOF
fi
EOT
  }
}

resource "random_password" "pg_password" {
  length             = 16
  special            = true
}

output "pg_password" {
  value     = random_password.pg_password.result
  sensitive = true
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = "postgres"
  }
}

resource "helm_release" "postgresql" {
  name       = "my-postgresql"
  namespace  = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.2.1"
  create_namespace = true

  set {
    name  = "auth.postgresPassword"
    value = random_password.pg_password.result
  }
  set {
    name  = "postgresql.postgresqlUsername"
    value = "postgres"
  }

  depends_on = [
    null_resource.create_kind_cluster,
    kubernetes_namespace.postgres
  ]
}





