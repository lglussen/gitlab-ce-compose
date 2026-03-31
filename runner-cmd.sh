echo "hello gitlab runner fans!"

function register {
    echo attempting to register runner ...
    ROOT_PAT_FILE=/var/opt/gitlab_init/root_pat
    RUNNER_AUTH=/var/opt/gitlab_init/runner_auth.$(hostname)
    while [ ! -f "$ROOT_PAT_FILE" ]; do echo "waiting for auth file ..."; sleep 5; done
    PAT=$(cat $ROOT_PAT_FILE)
    
    # instance_type group_type project_type
    curl --request POST \
       --header "Private-Token: ${PAT}" \
       --header "Content-Type: application/json" \
       --data '{
           "runner_type": "instance_type",
  	   "description": "Default linux runner (Fedora Container)",
           "tag_list": ["fedora", "linux"],
           "run_untagged": true
       }' "http://${GITLAB_HOST}:$GITLAB_PORT/api/v4/user/runners" > $RUNNER_AUTH 
    
    REGISTRATION_TOKEN=$(cat $RUNNER_AUTH | jq -r .token)
    gitlab-runner register \
       	--non-interactive \
       	--url http://$GITLAB_HOST:$GITLAB_PORT \
        --registration-token $REGISTRATION_TOKEN \
        --executor $EXECUTOR \
        --name $RUNNER_NAME
}

if [ ! -f /etc/gitlab-runner/config.toml ]; then
    register
else
    echo runner appears to be registered already
fi

gitlab-runner run
