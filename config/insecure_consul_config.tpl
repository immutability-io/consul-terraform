{
    "bootstrap_expect" : 3,
    "server" : true,
    "ui" : true,
    "datacenter" : "${datacenter}",
    "data_dir" : "/opt/consul/data",
    "log_level" : "INFO",
    "enable_syslog" : true,
    "disable_remote_exec": true,
    "retry_join" : ["${retry_join}"],
    "rejoin_after_leave": true
}
