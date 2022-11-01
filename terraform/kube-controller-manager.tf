resource tls_private_key controller_manager {
    count = length(var.master_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request controller_manager {
    count = length(var.master_nodes)

    private_key_pem = tls_private_key.controller_manager[count.index].private_key_pem

    subject {
        common_name  = "system:kube-controller-manager"
        organization = "system:kube-controller-manager"
    }
}

resource tls_locally_signed_cert controller_manager {
    count = length(var.master_nodes)

    cert_request_pem = tls_cert_request.controller_manager[count.index].cert_request_pem

    ca_private_key_pem    = tls_private_key.kube_ca.private_key_pem
    ca_cert_pem           = tls_self_signed_cert.kube_ca.cert_pem
    validity_period_hours = var.validity_period

    allowed_uses = [
        "key_encipherment",
        "digital_signature",
        "server_auth",
        "client_auth",
    ]
}
