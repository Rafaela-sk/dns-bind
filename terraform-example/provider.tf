terraform {
  required_version = "~> 1.5.0"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = "~> 3.3.2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.19.0"
    }
  }
}

provider "dns" {
  update {
    server        = var.DNS_SERVER_IP
    key_name      = var.DNS_SERVER_KEY_NAME
    key_algorithm = var.DNS_SERVER_KEY_ALGORITHM
    key_secret    = var.DNS_KEY_SECRET
  }
}

provider "vault" {
  address = var.VAULT_ADDR
  skip_tls_verify = true
  auth_login {
    path = var.AUTH_APPROLE

    parameters = {
      role_id   = var.ROLE_ID
      secret_id = var.SECRET_ID
    }
  }
}