output control_plane {
    sensitive = true
    value = [
        for index in range(length(var.master_nodes)) : {
            "kubernetes_pki": {
                # Only one for the whole cluster
                "ca": {
                    "key": tls_private_key.kube_ca.private_key_pem,
                    "cert": tls_self_signed_cert.kube_ca.cert_pem,
                },
                "service_accounts": {
                    "key": tls_private_key.service_accounts.private_key_pem,
                    "cert": tls_locally_signed_cert.service_accounts.cert_pem,
                },
                # Cert pair per node
                "kube_apiserver": {
                    "key": tls_private_key.apiserver[index].private_key_pem,
                    "cert": tls_locally_signed_cert.apiserver[index].cert_pem,
                },
                "kube_controller_manager": {
                    "key": tls_private_key.controller_manager[index].private_key_pem,
                    "cert": tls_locally_signed_cert.controller_manager[index].cert_pem,
                },
                "kube_scheduler": {
                    "key": tls_private_key.scheduler[index].private_key_pem,
                    "cert": tls_locally_signed_cert.scheduler[index].cert_pem,
                },
                "kubelet": {
                    "key": tls_private_key.kubelet_control_plane[index].private_key_pem,
                    "cert": tls_locally_signed_cert.kubelet_control_plane[index].cert_pem,
                },
                "etcd_client": {
                    "key": tls_private_key.etcd_client[index].private_key_pem,
                    "cert": tls_locally_signed_cert.etcd_client[index].cert_pem,
                },
            },
        }
    ]
}

output workers {
    sensitive = true
    value = [
        for index in range(length(var.worker_nodes)) : {
            "kubernetes_pki": {
                # Only one for the whole cluster
                "ca": {
                    "cert": tls_self_signed_cert.kube_ca.cert_pem,
                },
                # Cert pair per node
                "kubelet": {
                    "key": tls_private_key.kubelet_workers[index].private_key_pem,
                    "cert": tls_locally_signed_cert.kubelet_workers[index].cert_pem,
                },
            },
        }
    ]
}
