terraform {
 required_providers {
  random = {
   source = "hashicorp/random"
   version = "~> 3.0"
  }
  
  kubernetes = {
   source = "hashicorp/kubernetes"
   version = "~> 2.0"
  }
  helm = {
   source = "hashicorp/helm"
   version = "~> 2.0"
  }
 }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "kind-terraform-cluster"
}

provider "random" {}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "kind-terraform-cluster"
  }
}

