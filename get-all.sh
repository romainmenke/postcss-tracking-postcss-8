#!/usr/bin/env bash
set -e

mkdir -p repos
cd ./repos
current_dir=$(pwd)

for x in $(curl -s https://api.github.com/orgs/postcss/repos\?per_page=200 | jq -r '.[]|.html_url'); do
	if [ -d "$(basename $x)" ]; then
		cd $(basename $x);

		git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@');
		git pull;

		cd $current_dir;
	else
		git clone "${x}.git";
	fi
done
