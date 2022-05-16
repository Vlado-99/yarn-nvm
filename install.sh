#!/bin/bash
DEPENDENCIES=( curl jq )

function have_package()
{
	dpkg -l "$1" >/dev/null 2>&1
}

function install()
{
	>&2 echo "About to install missing packages: $@"
	sudo apt install "$@"
}

function check_missing_packages()
{
	local p
	for p in "$@" ; do
		if ! have_package "$p" ; then
			echo "$p"
		fi
	done
}

NEED_INSTALL=( $(check_missing_packages "${DEPENDENCIES[@]}") )
if [ "${#NEED_INSTALL[@]}" -gt 0 ] ; then
	install "${NEED_INSTALL[@]}"
fi

mkdir -p "$HOME/bin"
curl https://raw.githubusercontent.com/Vlado-99/yarn-nvm/main/yarn-nvm.bash -o "$HOME/bin/yarn-nvm.bash"
HOOK='[ -n "$(which yarn)" -a -n "$(command -v nvm)" -a -f "$HOME/bin/yarn-nvm.bash" ] && source "$HOME/bin/yarn-nvm.bash"'
if ! grep -qF "$HOOK" "$HOME/.bashrc" ; then
	echo "$HOOK" >>"$HOME/.bashrc"
	echo "" >>"$HOME/.bashrc"
fi

source "$HOME/.bashrc"

echo Done.

