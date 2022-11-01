resource tls_private_key apiserver {
    count = length(var.master_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request apiserver {
    count = length(var.master_nodes)

    private_key_pem = tls_private_key.apiserver[count.index].private_key_pem

    subject {
        common_name  = "kubernetes"
        organization = "kubernetes"
    }

    dns_names = [
        var.master_nodes[count.index].hostname,
        "${var.master_nodes[count.index].hostname}.${var.domain}",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.${var.cluster_name}",
    ]

    ip_addresses = [
        cidrhost(var.service_cidr, 1),
        var.master_nodes[count.index].ip,
        "127.0.0.1",
    ]
}

resource tls_locally_signed_cert apiserver {
    count = length(var.master_nodes)

    cert_request_pem = tls_cert_request.apiserver[count.index].cert_request_pem

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
