# Retrieving values from Vault

#data "vault_generic_secret" "dns_server_key" {
#  path = "${var.VAULT_PATH}/${var.DNS_SERVER_KEY_NAME_PATH}"
#}

#data "vault_generic_secret" "dns_server_secret" {
#  path = "${var.VAULT_PATH}/${var.DNS_SERVER_KEY_SECRET_PATH}"
#}

# Load Records 
locals {
    rafaela_A_records     = jsondecode(file("${path.module}/lab.rafaela.sk-A-Record.json"))
    rafaela_CNAME_records = jsondecode(file("${path.module}/lab.rafaela.sk-CNAME-records.json"))
}

# Update configuration
resource "dns_a_record_set" "a_records_rafaela" {
    for_each = local.rafaela_A_records

    zone = var.DNS_ZONE
    name = each.key
    addresses = [each.value]
    ttl = 300
}


# The Terraform Provider unexpectedly returned no resource state after having no errors in the resource creation. This is always an
# issue in the Terraform Provider and should be reported to the provider developers.

#resource "dns_cname_record" "cnames_rafaela" {
#    for_each = local.rafaela_CNAME_records

#    zone  = var.DNS_ZONE
#    name  = each.key
#    cname = "${each.value}.${var.DNS_ZONE}"
#    ttl   = 300
#}
