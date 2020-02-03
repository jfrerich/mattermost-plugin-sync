# mattermost-plugin-sync

This repo contains a Makefile and script to help automate some of the processes needed to merge the latest common files from https://github.com/mattermost/mattermost-plugin-starter-template to any plugin repo.

The Makefile contains commands to to the following process

* clone `mattermost-plugin-starter-template`
* clone plugin repo (uses args to `make`)
  * Example: `plugin_repo=mattermost-plugin-jira github_profile=mattermost`
* create new branch from master (in plugin repo)
* run [script](runme.zsh) to copy common files from `starter-template` to plugin repo
* `git status` will show any differences between the plugin repo and the latest common files in `mattermost-plugin-starter-template`

included common files are included in [script](runme.zsh) as an array.
