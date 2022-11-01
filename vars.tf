variable validity_period {
    description = <<-EOF
        Validity period of the self-signed certificates (in hours).
        Default is 1 year.
        EOF

    type = number
    default = 24 * 365
}

variable service_cidr {
    description = <<-EOF
        The CIDR for this cluster's service network. It is needed to calculate the first
        IP that would be used by the domain "kubernetes.default.svc".
        EOF

    type = string
    default = "192.168.1.0/24"
}

variable cluster_name {
    description = <<-EOF
        DNS for the cluster to bootstrap
        Default to "cluster.local"
        EOF

    type = string
    default = "cluster.local"
}

variable domain {
    description = <<-EOF
        The domain that the hosts of this cluster are going to use.
        E.g.: if a master node is called "master-1" and this value is set
        to "fake-domain.tld", its FQDN would be "master-1.fake-domain.tld"
        This FQDN will be added to certificate's DNS names.
        EOF

    type = string
    default = "cluster.local"
}

variable etcd_nodes {
    description = <<-EOF
        Object to declare which nodes will be the etcd nodes
        It is needed to set hostname and IP to the cert so it is valid.
        Defaults to one node called "master-1" with IP "192.168.0.201"
        EOF

    type = list(object({
        hostname = string
        ip = string
    }))
    default = [{
        "hostname": "master-1",
        "ip": "192.168.0.201",
    }]
}

variable master_nodes {
    description = <<-EOF
        Object to declare which will be the master nodes
        It is needed to set hostname and IP to the cert so it is valid.
        Defaults to one node called "master-1" with IP "192.168.0.201"
        EOF

    type = list(object({
        hostname = string
        ip = string
    }))
    default = [{
        "hostname": "master-1",
        "ip": "192.168.0.201",
    }]
}

variable worker_nodes {
    description = <<-EOF
        Object to declare which will be the worker nodes
        It is needed to set hostname and IP to the cert so it is valid.
        Defaults to one node called "worker-1" with IP "192.168.0.211"
        EOF

    type = list(object({
        hostname = string
        ip = string
    }))
    default = [{
        "hostname": "worker-1",
        "ip": "192.168.0.211",
    }]
}
