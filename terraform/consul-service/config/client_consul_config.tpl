{
    "datacenter" : "${datacenter}",
    "data_dir" : "/opt/consul/data",
    "log_level" : "INFO",
    "enable_syslog" : true,
    "disable_remote_exec": true,
    "encrypt": "${gossip_encryption_key}",
    "retry_join" : ["${retry_join}"],
    "rejoin_after_leave": true,
    "ca_file": "/etc/consul.d/root.crt"
}
