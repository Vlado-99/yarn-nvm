# source into .bashrc

function _dbg()
{
	#>&2 echo "$@"
	true # no-op
}

function find_project_node_version()
{
	local dir="$1" request_ver f
	[ -d "$dir" ] || dir=$(pwd)
	for f in "$dir/package.json" "$dir/../package.json" "$dir/../../package.json" ; do
		if [ -f "$f" ] ; then
			request_ver=$(cat "$f" | jq .engines.node)
			if [ -n "$request_ver" ] ; then
				echo "$request_ver"
				return
			fi
		fi
	done
}

function find_workspace_dir()
{
	while [ -n "$1" ] ; do
		if [ "$1" == 'workspace' -o "$1" == '--cwd' ] ; then
			echo "$(pwd)/$2"
		fi
		shift
	done
}

function match_version()
{
	# semantic versioning is not supported yet
	local a="$1" b="$2"
	for ((i=0; i<${#a}; i++)) ; do
		if [ "${a:$i,1}" != "${b:$i:1}" ] ; then
			return 1 # diferent
		fi
	done
	return 0 # matches
}

function switch_project_node_version()
{
	_dbg "switch_project_node_version()"
	local dir="$(find_workspace_dir "$@")"
	_dbg "dir=$dir"
	local have_ver="$(nvm version | tr -dc 0-9.)"
	_dbg "have_ver=$have_ver"
	local need_ver="$(find_project_node_version "$dir" | tr -dc 0-9.)"
	_dbg "need_ver=$need_ver"
	if [ -z "$need_ver" ] ; then
		need_ver=$(nvm ls stable | tr -dc 0-9.)
		_dbg "need_ver=$need_ver"
	fi
	if ! match_version "$need_ver" "$have_ver" ; then
		echo "Switching to version $need_ver"
		nvm use "$need_ver"
	fi
}

function yarn()
{
	_dbg YARN func
	switch_project_node_version "$@"
	command yarn "$@"
}

