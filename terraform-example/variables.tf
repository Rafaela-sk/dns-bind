variable "DNS_SERVER_IP" {
  type        = string
  description = "DNS Server IP"
}

variable "DNS_SERVER_KEY_NAME" {
  type        = string
  description = "DNS Server Key Name"
}

variable "DNS_SERVER_KEY_ALGORITHM" {
  type        = string
  description = "DNS Server Key Algorithm"
}

variable "DNS_KEY_SECRET" {
  type        = string
  description = "DNS Server Secret"
}

variable "DNS_ZONE" {
  type        = string
  description = "DNS Server Zone"
}

variable "DNS_ZONE_SET_NAME" {
  type        = string
  description = "DNS Server Zone Name"
}

variable "VAULT_ADDR" {
  type        = string
  description = "Vault Server IP / FQDN:PORT"
}

variable "ROLE_ID" {
  type        = string
  description = "Vault Server Role"
}

variable "SECRET_ID" {
  type        = string
  description = "Vault Server Secret"
}

variable "VAULT_PATH" {
  type        = string
  description = "Vault Server Secrets Path"
}

variable "AUTH_APPROLE" {
  type        = string
  description = "Vault Server Secrets Path"
}

variable "DNS_SERVER_KEY_NAME_PATH" {
  type        = string
  description = "DNS Server Key Path"
}

variable "DNS_SERVER_KEY_SECRET_PATH" {
  type        = string
  description = "DNS Server Secret Path"
}