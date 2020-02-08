SHELL := bash

plugin_repo ?= 
github_profile ?= 

PLUGIN_TEMPLATE_DIR = mattermost-plugin-starter-template
PLUGIN_TEMPLATE_REPO = mattermost/$(PLUGIN_TEMPLATE_DIR)

A=$(shell cd $(plugin_repo)/webapp; sh -c 'npm audit > /dev/null 2>&1'; echo $$? )
# B=$(shell cd $(plugin_repo)/webapp; echo $$? )
# include setup.mk


## print all help if not target specified
@empty: help
.PHONY: empty

# reference: https://stackoverflow.com/questions/15229833/set-makefile-variable-inside-target#15230658
# -- used target of same name to define a variable to be used later
#  (createbranch target)
## sync latest starter template files to a plugin
sync: branchname=sync-to-starter-plugin-branch
sync: check-plugin-defined sync-copystarterfiles createbranch
.PHONY: sync

## bumps a version of plugin 
bump: branchname=bump-plugin-version
bump: check-plugin-defined cloneplugin clonestartertemplate createbranch
.PHONY: bump


## check npm audit inside a plugin repo
# security: branchname=bump-dependency-versions
# security: check-plugin-defined 
security:
ifeq ("a", "z")
	echo "npm audit passed!" 
	echo $A
else ("a", "a")
	echo "npm audit failed" 
endif

		# if [ "a" == "a" ]; then \
		# 	echo "npm audit passed!" \
		# fi

## check required CLI inputs are set
check-plugin-defined:
ifeq ($(plugin_repo),)
	$(error "Please supply a plugin repo (Ex. plugin_repo=mattermost-plugin-jira)")
endif
ifeq ($(github_profile),)
	$(error "Please supply a github profile (Ex. github_profile=mattermost)")
endif

## clones the mattermost-plugin-starter-template repo
.PHONY: clonestartertemplate
clonestartertemplate:
	echo cloning $(PLUGIN_TEMPLATE_REPO)
	hub clone $(PLUGIN_TEMPLATE_REPO)

## clones the plugin repo for syncing with starter-template
.PHONY: cloneplugin
cloneplugin: check-plugin-defined
	echo cloning "$(github_profile)/$(plugin_repo)"
	hub clone "$(github_profile)/$(plugin_repo)"

.PHONY: createbranch
## creates plugin branch (from master) for preparing diff and PR
createbranch: 
	echo creating sync branch for $(plugin_repo)
	cd $(plugin_repo) \
	&& git pull \
	&& git checkout -b $(branchname) \
	&& cd ..;

## copy common files from mattermost-plugin-starter-template to plugin repo
.PHONY: sync-copystarterfiles
sync-copystarterfiles: clonestartertemplate cloneplugin
	echo "copying common files from $(PLUGIN_TEMPLATE_DIR) to $(plugin_repo)"
	zsh ./runme.zsh $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)

## clean will rm -rf the plugin and starter-template directories
.PHONY: clean
clean: check-plugin-defined
	echo "rm -rf $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)"
	rm -rf $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)

# Help documentation à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@cat Makefile | grep -v '\.PHONY' |  grep -v '\help:' | grep -B1 -E '^[a-zA-Z0-9_.-]+:.*' | sed -e "s/:.*//" | sed -e "s/^## //" |  grep -v '\-\-' | sed '1!G;h;$$!d' | awk 'NR%2{printf "\033[36m%-30s\033[0m",$$0;next;}1' | sort
