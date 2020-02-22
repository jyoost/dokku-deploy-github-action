#!/bin/bash

SSH_PRIVATE_KEY=$1
SSH_DEPLOYMENT_KEY=$2
DOKKU_USER=$3
DOKKU_HOST=$4
DOKKU_APP_NAME=$5
DOKKU_REMOTE_BRANCH=$6

echo "Adding SSH key"
# Setup the SSH environment
mkdir -p ~/.ssh
eval `ssh-agent -s`
ssh-add - <<< "$SSH_PRIVATE_KEY"
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
ssh-keyscan $DOKKU_HOST >> ~/.ssh/known_hosts
chown 400 ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# echo "$SSH_DEPLOYMENT_KEY" | ssh-add -

# Setup the git environment
git_repo="$DOKKU_USER@$DOKKU_HOST:$DOKKU_APP_NAME"
cd "$GITHUB_WORKSPACE"
git remote add deploy "$git_repo"

# Prepare to push to Dokku git repository
REMOTE_REF="$GITHUB_SHA:refs/heads/$DOKKU_REMOTE_BRANCH"

GIT_COMMAND="git push deploy $REMOTE_REF
echo "GIT_COMMAND=$GIT_COMMAND"

# Push to Dokku git repository
# GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" $GIT_COMMAND
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" $GIT_COMMAND
