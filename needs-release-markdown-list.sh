#!/usr/bin/env bash
set -e

used_by_preset_env=$(sh ./postcss-preset-env-dependencies.sh)

cd ./repos
current_dir=$(pwd)

preset_env_out=""
preset_env_needs_release=0
preset_env_been_released=0

remainer=""
needs_release=0
been_released=0

for x in $(ls); do
	cd $x;

	echo "checkin \"$x\" ...";

	if [ -f ./package.json ]; then
		package_name=$(cat package.json | jq -r '.name')
		package_info_tmp_file=$(sh ../../get-release-info.sh $package_name)
		if [ "$package_info_tmp_file" ]; then
			postcss_dependency=$(cat $package_info_tmp_file | jq -r '.dependencies.postcss')
			postcss_peer_dependency=$(cat $package_info_tmp_file | jq -r '.peerDependencies.postcss')
			rm "$package_info_tmp_file"

			preset_env_marker="";
			for y in ${used_by_preset_env}; do 
				if [ "$y" == "$package_name" ]; then
					preset_env_marker="true"
				fi
			done

			if [ "$preset_env_marker" ]; then
				if [ "$postcss_dependency" != "null" ]; then
					preset_env_out="${preset_env_out}\n- [ ] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_dependency}"

					let preset_env_needs_release=preset_env_needs_release+1;
				fi

				if [ "$postcss_peer_dependency" != "null" ]; then
					preset_env_out="${preset_env_out}\n- [x] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_peer_dependency}"

					let preset_env_been_released=preset_env_been_released+1;
				fi
			else
				if [ "$postcss_dependency" != "null" ]; then
					remainder="${remainder}\n- [ ] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_dependency}"

					let needs_release=needs_release+1;
				fi

				if [ "$postcss_peer_dependency" != "null" ]; then
					remainder="${remainder}\n- [x] [${x}](https://github.com/postcss/${x}) - postcss : ${postcss_peer_dependency}"

					let been_released=been_released+1;
				fi
			fi
		fi
	fi

	cd $current_dir;
done

echo $preset_env_out;
echo "\n${preset_env_needs_release} projects need releasing"
echo "\n${preset_env_been_released} projects done"

echo $remainder;
echo "\n${needs_release} projects need releasing"
echo "\n${been_released} projects done"
