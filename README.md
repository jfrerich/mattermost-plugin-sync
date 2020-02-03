# mattermost-plugin-sync

This repo contains a Makefile and script to help automate some of the processes needed to merge the latest common files from https://github.com/mattermost/mattermost-plugin-starter-template to any plugin repo.

### Instructions

* git clone https://github.com/jfrerich/mattermost-plugin-sync
* cd `mattermost-plugin-sync/`
* `make plugin_repo=<plugin_repo_name> github_profile=<profile>`
  * Example:
  * `make plugin_repo=mattermost-plugin-jira github_profile=mattermost`

### Makefile contents
The Makefile contains commands to to the following process

* clone `mattermost-plugin-starter-template`
* clone plugin repo (uses args to `make`)
  * Example: `plugin_repo=mattermost-plugin-jira github_profile=mattermost`
* create new branch from master (in plugin repo)
* run [script](runme.zsh) to copy common files from `starter-template` to plugin repo
* `git status` will show any differences between the plugin repo and the latest common files in `mattermost-plugin-starter-template`

Included common files are added to the `include_files` array in [script](runme.zsh).

```sh
# root dir
include_files=(.editorconfig)
include_files+=.gitattributes
include_files+=.gitignore
include_files+=LICENSE
include_files+=Makefile
# server dir
include_files+=server/.gitignore
# webapp dir
include_files+=webapp/.eslintrc.json 
include_files+=webapp/.gitignore
include_files+=webapp/babel.config.js
include_files+=webapp/tsconfig.json
include_files+=webapp/webpack.config.js
```
