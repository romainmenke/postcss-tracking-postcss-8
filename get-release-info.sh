err_file=$(mktemp)
info_file=$(mktemp)
npm info $1 --json 2> "$err_file" 1> "$info_file"
status="$?"
rm "$err_file"

if [ "$status" == "0" ]; then
	echo $info_file;
else
	rm "$info_file"
	exit 0;
fi
