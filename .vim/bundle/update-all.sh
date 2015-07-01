DIR=$(dirname $0)
PLUGINS=$(find $DIR -maxdepth 1 -type d | tail -n +2)

for plugin in $PLUGINS; do
	pushd $plugin >/dev/null
	if [ ! -d .git ]; then
		popd
	else
		desc=`cat .git/description`
		echo -e "\n\033[33mUpdating \033[1m$desc\033[0;33m...\033[0m"
		git pull origin master
		popd >/dev/null
	fi
done

