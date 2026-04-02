# Gitlab CE & Runner
This project sets up Gitlab CE and automaticaly configures a default runner for quickly generating a GitLab test environment.

# Setup
```shell
podman-compose build
podman-compose up -d
```
wait until both the `gitlab_ce` and `gitlab_runner` containers are up

```shell
podman exec -it gitlab_ce cat /etc/gitlab/initial_root_password | grep Password
```

Navigate to http://gitlab_ce:8929 and log-in as root

**NOTE**: if you modify the `/etc/hosts` file to map `gitlab_ce` to `127.0.0.1` on the machine running podman, this can mess up the internal container DNS for short name resolution.
This is because podman will copy the the `/etc/hosts` file into the containers by default.
If you are trying to access gitlab from the same machine running the containers, consider modifying the `$HOME/.config/containers/containers.conf` file
```toml
[containers]
base_hosts_file = "none"
```
if you plan to add `gitlab_ce` to your `/etc/hosts` file.
