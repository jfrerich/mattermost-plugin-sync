PLUGIN_TEMPLATE_DIR=mattermost-plugin-starter-template
PLUGIN_TEMPLATE_REPO=mattermost/$PLUGIN_TEMPLATE_DIR

PLUGIN_DIR=mattermost-plugin-jira
PLUGIN_REPO=mattermost/$PLUGIN_DIR

declare -a include_files
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

## TODO use exclude, instead of include so new files added starter template will get added in copy
# for key in ${(kv)exclude_files}; do
# echo "k -> " ${(k)exclude_files}
# done

for (( i = 1; i <= ${#include_files}; i++ )); do
  echo "cp " ${PLUGIN_TEMPLATE_DIR}/${include_files[i]} ${PLUGIN_DIR}/${include_files[i]}
  cp ${PLUGIN_TEMPLATE_DIR}/${include_files[i]} ${PLUGIN_DIR}/${include_files[i]}
done
