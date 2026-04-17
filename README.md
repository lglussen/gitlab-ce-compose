# Gitlab CE & Runner
This project sets up Gitlab CE and automaticaly configures a default runner for quickly generating a GitLab test environment.

# Setup
```shell
podman-compose build
podman-compose up -d
```
wait until both the `gitlab_ce` and `gitlab_runner` containers are up.
Please note that this may take 10-15 minutes on the first run.
It may look like the process is hanging and this may be confusing give that the background `-d` was given:
but this is because the second container `gitlab_runner` is not launched until the `gitlab_ce` container is passing its healthcheck.
Compose will background the processes and exit as soon as the final container is started.

```shell
podman exec -it gitlab_ce cat /etc/gitlab/initial_root_password | grep Password
```

Navigate to `http://localhost:8929` and log-in as root.

## Warning on using `/etc/hosts`
It can be desirable to use the same "dns" entry configured in gitlab rather than `localhost` to avoid warnings and potential issues.

If you modify the `/etc/hosts` file to map `gitlab_ce` to `127.0.0.1` on the machine running podman, this can mess up the internal container DNS for short name resolution.
This is because podman will copy the the `/etc/hosts` file into the containers by default.
If you are trying to access gitlab from the same machine running the containers, consider modifying the `$HOME/.config/containers/containers.conf` file
```toml
[containers]
base_hosts_file = "none"
```
This way you may add `gitlab_ce` to your `/etc/hosts` file without causing issues.


