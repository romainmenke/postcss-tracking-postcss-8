#!/usr/bin/env bash
set -e

used_by_preset_env=$(sh ./postcss-preset-env-dependencies.sh)

cd ./repos
current_dir=$(pwd)

preset_env_out=""
preset_env_needs_update=0
preset_env_been_updated=0

remainer=""
needs_update=0
been_updated=0

for x in $(ls); do
	cd $x;

	if [ -f ./package.json ]; then
		package_name=$(cat package.json | jq -r '.name')
		postcss_dependency=$(cat package.json | jq -r '.dependencies.postcss')

		preset_env_marker="";
		for y in ${used_by_preset_env}; do 
			if [ "$y" == "$package_name" ]; then
				preset_env_marker="true"
			fi
		done

		if [ "$preset_env_marker" ]; then
			if [ "$postcss_dependency" != "null" ]; then
				preset_env_out="${preset_env_out}\n- [ ] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_dependency}"

				let preset_env_needs_update=preset_env_needs_update+1;
			fi

			postcss_peer_dependency=$(cat package.json | jq -r '.peerDependencies.postcss')
			if [ "$postcss_peer_dependency" != "null" ]; then
				preset_env_out="${preset_env_out}\n- [x] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_peer_dependency}"

				let preset_env_been_updated=preset_env_been_updated+1;
			fi
		else
			if [ "$postcss_dependency" != "null" ]; then
				remainder="${remainder}\n- [ ] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_dependency}"

				let needs_update=needs_update+1;
			fi

			postcss_peer_dependency=$(cat package.json | jq -r '.peerDependencies.postcss')
			if [ "$postcss_peer_dependency" != "null" ]; then
				remainder="${remainder}\n- [x] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_peer_dependency}"

				let been_updated=been_updated+1;
			fi
		fi
	fi

	cd $current_dir;
done

echo $preset_env_out;
echo "\n${preset_env_needs_update} projects need updating"
echo "\n${preset_env_been_updated} projects done"

echo $remainder;
echo "\n${needs_update} projects need updating"
echo "\n${been_updated} projects done"
