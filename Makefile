plugin_repo ?= 
github_profile ?= 

PLUGIN_TEMPLATE_DIR = mattermost-plugin-starter-template
PLUGIN_TEMPLATE_REPO = mattermost/$(PLUGIN_TEMPLATE_DIR)

# include setup.mk

## print all help if not target specified
@empty: help
.PHONY: empty

## sync latest starter template files to a plugin
sync: check-plugin-defined sync-copystarterfiles createbranch
	# branchname := sync-to-starter-plugin-branch

## bumps a version of plugin 
bump: check-plugin-defined cloneplugin
	# branchname := sync-to-starter-plugin-branch

some_recipe:
	sh -c 'exit 123'; || (echo "thid failed")

# reference: https://stackoverflow.com/questions/15229833/set-makefile-variable-inside-target#15230658
## check npm audit inside a plugin repo
security: branchname=bump-dependency-versions
# security: check-plugin-defined cloneplugin createbranch
security: 
	cd $(plugin_repo)/webapp; sh -c 'npm audit > /dev/null 2>&1'; echo $?; 
	# EXIT_CODE=$?
	# echo "exit code =  $(EXIT_CODE)"
	# EXIT_CODE=$?;
	# @echo "exit code = $(EXIT_CODE)"
	#
	# cd $(plugin_repo)/webapp;\
	# sh -c 'npm audit';
	# EXIT_CODE=$?;
	# @echo "exit code = $(EXIT_CODE)"
	#
	# if [ $OUT -eq 0 ]; then
	# 	echo "npm audit failed.. Need to run npm audit fix"
	# else
	# 	echo "npm audit fix passed"
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
createbranch: check-plugin-defined cloneplugin
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
