# #########################################################################################
#    etcd CA
# #########################################################################################
resource tls_private_key etcd_ca {
    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_self_signed_cert etcd_ca {
  private_key_pem = tls_private_key.etcd_ca.private_key_pem

  subject {
    common_name  = "etcd-ca"
    organization = "etcd"
  }

  is_ca_certificate     = true
  validity_period_hours = var.validity_period

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}


# #########################################################################################
#    etcd Server
# #########################################################################################
resource tls_private_key etcd_server {
    count = length(var.etcd_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request etcd_server {
    count = length(var.etcd_nodes)

    private_key_pem = tls_private_key.etcd_server[count.index].private_key_pem

    subject {
        common_name  = "etcd"
        organization = "etcd"
    }

    dns_names = [
        "localhost",
        "*.etcd.kube-system.svc.${var.cluster_name}",
        var.etcd_nodes[count.index].hostname,
        "${var.etcd_nodes[count.index].hostname}.${var.domain}",
    ]

    ip_addresses = [
        "127.0.0.1",
        var.etcd_nodes[count.index].ip,
    ]
}

resource tls_locally_signed_cert etcd_server {
    count = length(var.etcd_nodes)

    cert_request_pem = tls_cert_request.etcd_server[count.index].cert_request_pem

    ca_private_key_pem    = tls_private_key.etcd_ca.private_key_pem
    ca_cert_pem           = tls_self_signed_cert.etcd_ca.cert_pem
    validity_period_hours = var.validity_period

    allowed_uses = [
        "key_encipherment",
        "server_auth",
    ]
}


# #########################################################################################
#    etcd peers
# #########################################################################################
resource tls_private_key etcd_peer {
    count = length(var.etcd_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request etcd_peer {
    count = length(var.etcd_nodes)

    private_key_pem = tls_private_key.etcd_peer[count.index].private_key_pem

    subject {
        common_name  = "etcd"
        organization = "etcd"
    }

    dns_names = [
        "localhost",
        "*.etcd.kube-system.svc.${var.cluster_name}",
        var.etcd_nodes[count.index].hostname,
    ]

    ip_addresses = [
        "127.0.0.1",
        var.etcd_nodes[count.index].ip,
    ]
}

resource tls_locally_signed_cert etcd_peer {
    count = length(var.etcd_nodes)

    cert_request_pem = tls_cert_request.etcd_peer[count.index].cert_request_pem

    ca_private_key_pem    = tls_private_key.etcd_ca.private_key_pem
    ca_cert_pem           = tls_self_signed_cert.etcd_ca.cert_pem
    validity_period_hours = var.validity_period

    allowed_uses = [
        "key_encipherment",
        "server_auth",
        "client_auth",
    ]
}


# #########################################################################################
#    etcd client
# #########################################################################################
resource tls_private_key etcd_client {
    count = length(var.master_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request etcd_client {
    count = length(var.master_nodes)

    private_key_pem = tls_private_key.etcd_client[count.index].private_key_pem

    subject {
        common_name  = "etcd"
        organization = "etcd"
    }

    dns_names = [
        var.master_nodes[count.index].hostname,
    ]

    ip_addresses = [
        var.master_nodes[count.index].ip,
    ]
}

resource tls_locally_signed_cert etcd_client {
    count = length(var.master_nodes)

    cert_request_pem = tls_cert_request.etcd_client[count.index].cert_request_pem

    ca_private_key_pem    = tls_private_key.etcd_ca.private_key_pem
    ca_cert_pem           = tls_self_signed_cert.etcd_ca.cert_pem
    validity_period_hours = var.validity_period

    allowed_uses = [
        "key_encipherment",
        "client_auth",
    ]
}
