# #########################################################################################
#    Kubelet control plane
# #########################################################################################
resource tls_private_key kubelet_control_plane {
    count = length(var.master_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request kubelet_control_plane {
    count = length(var.master_nodes)

    private_key_pem = tls_private_key.kubelet_control_plane[count.index].private_key_pem

    subject {
        common_name  = "system:node:${var.master_nodes[count.index].hostname}"
        organization = "system:nodes"
    }

    dns_names = [
        var.master_nodes[count.index].hostname,
        "${var.master_nodes[count.index].hostname}.${var.domain}",
    ]

    ip_addresses = [
        cidrhost(var.service_cidr, 1),
        var.master_nodes[count.index].ip,
        "127.0.0.1",
    ]
}

resource tls_locally_signed_cert kubelet_control_plane {
    count = length(var.master_nodes)

    cert_request_pem = tls_cert_request.kubelet_control_plane[count.index].cert_request_pem

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

# #########################################################################################
#    Kubelet workers
# #########################################################################################
resource tls_private_key kubelet_workers {
    count = length(var.worker_nodes)

    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_cert_request kubelet_workers {
    count = length(var.worker_nodes)

    private_key_pem = tls_private_key.kubelet_workers[count.index].private_key_pem

    subject {
        common_name  = "system:node:${var.worker_nodes[count.index].hostname}"
        organization = "system:nodes"
    }

    dns_names = [
        var.worker_nodes[count.index].hostname,
        "${var.worker_nodes[count.index].hostname}.${var.domain}",
    ]

    ip_addresses = [
        cidrhost(var.service_cidr, 1),
        var.worker_nodes[count.index].ip,
        "127.0.0.1",
    ]
}

resource tls_locally_signed_cert kubelet_workers {
    count = length(var.worker_nodes)

    cert_request_pem = tls_cert_request.kubelet_workers[count.index].cert_request_pem

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
