# prets

fencing timing trainer

> https://ellemenno.xyz/prets



## development

to collect and serve the site files for testing via [localhost]:

```console
$ ./run.sh serve`
```

## publishing

this site is hosted via GitHub Pages from the [`gh-pages`][gh-pages] branch, tracked as a separate [git worktree] rooted at this directory.

to set up for publishing:
1. create a new [Personal Access Token][pat] on GitHub ([instructions][pat howto])
   - _Repository access | Only select repositories_
   - _Contents: Reand and Write_
1. add an untracked config file to this repo (`.env`):
   - `$ printf "DEPLOY_USER=uuu\nDEPLOY_TOKEN=ttt" > .env`
   - _(replace `uuu` and `ttt` with your username and personal access token)_
   - _`.env` should be kept out of source control to protect your secrets_
1. run the publish task
   - `./run.sh publish`



[gh-pages]: https://github.com/ellemenno/vbstats/tree/gh-pages "branch for GitHub Pages auto-deployments"
[git worktree]: https://git-scm.com/docs/git-worktree "git command to manage multiple working trees"
[localhost]: http://localhost:8080/ "local testing url"
[pat]: https://github.com/settings/personal-access-tokens/new "GitHub personal access tokens"
[pat howto]: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token "creating a personal access token"
[X1011]: https://github.com/X1011/git-directory-deploy "method for deploying a sub-directory of build files"