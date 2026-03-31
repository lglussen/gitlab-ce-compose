#!/bin/bash

ROOT_PAT_FILE=/var/opt/gitlab_init/root_pat
function auth_init {
  if [ ! -f "$ROOT_PAT_FILE" ]; then 
    while ! curl -s localhost:$GITLAB_PORT/-/readiness; do
      sleep 10
    done
    echo "gitlab ready, creating auth token ..."
    create_auth_token
  fi
}

function create_auth_token {
  AUTHTOKEN=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 32 | head -n 1)
  gitlab-rails runner "
user = User.find_by_username('root');
token = user.personal_access_tokens.create(
  scopes: [:api, :sudo],
  name: 'Automation Token',
  expires_at: 365.days.from_now
);
token.set_token('${AUTHTOKEN}');
token.save!"
  echo -n $AUTHTOKEN > $ROOT_PAT_FILE
}

auth_init &
/assets/init-container
