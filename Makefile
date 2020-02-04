plugin_repo ?= 
github_profile ?= 

PLUGIN_TEMPLATE_DIR = mattermost-plugin-starter-template
PLUGIN_TEMPLATE_REPO = mattermost/$(PLUGIN_TEMPLATE_DIR)

# include setup.mk

# clone repos and copy files
all: check-input copyfiles

check-input:
ifeq ($(plugin_repo),)
	$(error "Please supply a plugin repo (Ex. plugin_repo=mattermost-plugin-jira)")
endif

ifeq ($(github_profile),)
	$(error "Please supply a github profile  (Ex. github_profile=mattermost)")
endif

## clones the mattermost-plugin-starter-template repo
.PHONY: getstartertemplate
getstartertemplate:
	@echo cloning $(PLUGIN_TEMPLATE_REPO)
	hub clone $(PLUGIN_TEMPLATE_REPO)

## clones the plugin repo for syncing with starter-template
.PHONY: getpluginforsync
getpluginforsync: check-input getstartertemplate
	@echo cloning "$(github_profile)/$(plugin_repo)"
	hub clone "$(github_profile)/$(plugin_repo)"

.PHONY: pluginsyncbranch
## creates plugin branch (from master) for preparing diff and PR
pluginsyncbranch: check-input getpluginforsync
	@echo creating sync branch for $(plugin_repo)
	cd $(plugin_repo) \
	&& git pull \
	&& git checkout -b sync-to-starter-plugin-branch \
	&& cd ..;

## copy common files from mattermost-plugin-starter-template to plugin repo
.PHONY: copyfiles
copyfiles: check-input getstartertemplate getpluginforsync
	@echo "copying common files from $(PLUGIN_TEMPLATE_DIR) to $(plugin_repo)"
	zsh ./runme.zsh $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)

## clean will rm -rf the plugin and starter-template direcories
.PHONY: clean
clean: check-input
	@echo "rm -rf $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)"
	rm -rf $(PLUGIN_TEMPLATE_DIR) $(plugin_repo)

# Help documentation à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@cat Makefile | grep -v '\.PHONY' |  grep -v '\help:' | grep -B1 -E '^[a-zA-Z0-9_.-]+:.*' | sed -e "s/:.*//" | sed -e "s/^## //" |  grep -v '\-\-' | sed '1!G;h;$$!d' | awk 'NR%2{printf "\033[36m%-30s\033[0m",$$0;next;}1' | sort
