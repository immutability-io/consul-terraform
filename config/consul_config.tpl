{
    "bootstrap_expect" : 3,
    "server" : true,
    "datacenter" : "${datacenter}",
    "data_dir" : "/opt/consul/data",
    "log_level" : "INFO",
    "enable_syslog" : true,
    "disable_remote_exec": true,
    "retry_join" : ["${retry_join}"],
    "rejoin_after_leave": true,
    "ca_file": "/etc/consul.d/root.crt",
    "cert_file": "/etc/consul.d/consul.crt",
    "key_file": "/etc/consul.d/consul.key",
    "verify_incoming": true,
    "verify_outgoing": true
}
