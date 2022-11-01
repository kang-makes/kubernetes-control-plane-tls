resource tls_private_key kube_ca {
    algorithm = "RSA"
    rsa_bits  = "2048"
}

resource tls_self_signed_cert kube_ca {
    private_key_pem = tls_private_key.kube_ca.private_key_pem

    subject {
        common_name  = "kube-ca"
        organization = "bootkube"
    }

    is_ca_certificate     = true
    validity_period_hours = var.validity_period

    allowed_uses = [
        "key_encipherment",
        "digital_signature",
        "cert_signing",
    ]
}
