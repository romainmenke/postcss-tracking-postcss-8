#!/usr/bin/env bash
set -e

cd ./repos
current_dir=$(pwd)

counter=0

for x in $(ls); do
	cd $x;

	if [ -f ./package.json ]; then

		postcss_dependency=$(cat package.json | jq -r '.dependencies.postcss')
		if [ "$postcss_dependency" != "null" ]; then
			echo "${x}"
			echo "  - has postcss dependency : ${postcss_dependency}"
			echo "  - https://github.com/postcss/$x\n"

			let counter=counter+1;
		fi

	fi

	cd $current_dir;
done

echo "\n${counter} projects need updating"
