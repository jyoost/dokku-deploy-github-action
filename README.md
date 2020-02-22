# dokku-deploy-github-action

This action makes deployment to Dokku as easy as possible!

## Inputs

### ssh-private-key

The private ssh key used for Dokku deployments. Never use as plain text! Configure it as a secret in your repository by navigating to https://github.com/USERNAME/REPO/settings/secrets

**Required**

### dokku-user

The user to use for ssh. If not specified, "dokku" user will be used.

### dokku-host

The Dokku host to deploy to.

### app-name

The Dokku app name to be deployed.

### remote-branch

The branch to push on the remote repository. If not specified, `master` will be used.

### git-push-flags

You may set additional flags that will be passed to the `git push` command. You might want to set this parameter to `--force` if you're pushing to Dokku from other places and encounter the following error:
```
error: failed to push some refs to 'dokku@mydokkuhost.com:mydokkurepo'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

## Example

Note: `actions/checkout` must preceed this action in order for the repository data to be exposed for the action.
It is recommended to pass `actions/checkout` the `fetch-depth: 0` parameter to avoid errors such as `shallow update not allowed`

```yaml
name: Deploy to Dokku - production

on: [push]

env:
  DOKKU_HOST: 'my-host.com'
  DOKKU_APP_NAME: 'my-app-production'
  DOKKU_REMOTE_BRANCH: 'master'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Deploy
        uses: woudsma/dokku-deploy-github-action@v1
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
          dokku-host: ${{ env.DOKKU_HOST }}
          app-name: ${{ env.DOKKU_APP_NAME }}
          app-remote-branch: ${{ env.DOKKU_REMOTE_BRANCH }}

```
