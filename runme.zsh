PLUGIN_TEMPLATE_DIR=mattermost-plugin-starter-template
PLUGIN_TEMPLATE_REPO=mattermost/$PLUGIN_TEMPLATE_DIR

PLUGIN_DIR=mattermost-plugin-jira
PLUGIN_REPO=mattermost/$PLUGIN_DIR

declare -a exclude_files
exclude_files=(.editorconfig .gitattributes .gitignore LICENSE Makefile) 
exclude_files+=(server/.gitignore) 
exclude_files+=(webapp/.eslintrc.json webapp/.gitignore webapp/babel.config.js webapp/tsconfig.json webapp/webpack.config.js) 
# for key in ${(kv)exclude_files}; do
# echo "k -> " ${(k)exclude_files}
# done
for (( i = 1; i <= ${#exclude_files}; i++ )); do
  echo "cp " ${PLUGIN_TEMPLATE_DIR}/${exclude_files[i]} ${PLUGIN_DIR}/${exclude_files[i]}
  cp ${PLUGIN_TEMPLATE_DIR}/${exclude_files[i]} ${PLUGIN_DIR}/${exclude_files[i]}
done
