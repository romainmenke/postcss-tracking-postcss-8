#!/usr/bin/env bash
set -e

cd ./repos
current_dir=$(pwd)

needs_update=0
been_updated=0

for x in $(ls); do
	cd $x;

	if [ -f ./package.json ]; then

		postcss_dependency=$(cat package.json | jq -r '.dependencies.postcss')
		if [ "$postcss_dependency" != "null" ]; then
			echo "- [ ] (${x})[https://github.com/postcss/${x}] - postcss : ${postcss_dependency}"

			let needs_update=needs_update+1;
		fi

		postcss_peer_dependency=$(cat package.json | jq -r '.peerDependencies.postcss')
		if [ "$postcss_peer_dependency" != "null" ]; then
			echo "- [x] (${x})[https://github.com/postcss/${x}] - postcss : ${postcss_peer_dependency}"

			let been_updated=been_updated+1;
		fi

	fi

	cd $current_dir;
done

echo "\n${needs_update} projects need updating"
echo "\n${been_updated} projects done"
