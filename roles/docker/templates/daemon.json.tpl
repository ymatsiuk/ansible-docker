{
  "debug": false,
  "metrics-addr" : "127.0.0.1:9323",
  "experimental" : true,
  "storage-driver": "{{ docker_storage_driver }}",
  "data-root": "{{ docker_mounts.docker_dir.mount }}",
  "log-driver": "{{ docker_log_driver }}",
  "labels": {
      "role.type=services", 
      "role.service={{ group_names.split('-')[-1] }}"
  },
  "log-opts": {
    "fluentd-address": "127.0.0.1:24224"
  }
}
