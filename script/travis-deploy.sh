#!/bin/bash
set -eu

eval "$(ssh-agent -s)"
script/travis-decrypt.sh

set -x

chmod 600 keys/*.key

PUSH_ARGS=""
if [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then
	: using dry-run
	PUSH_ARGS="-n"
fi

function push() {
	dir="$1"
	shift 1
	pushd "$dir"
		if [ -e .push ]; then
			git push $PUSH_ARGS "$@"
		else
			: No changes 'in' $dir
		fi
	popd
}

function use_key {
	# github gets confused if you have 2 github deploy keys active at once
	ssh-add -D
	ssh-add "keys/$1.key"
}

use_key opam-repository
push opam-repository git@github.com:timbertson/opam-repository.git HEAD:master

use_key opam2nix-packages
push . git@github.com:timbertson/opam2nix-packages.git HEAD:"$TRAVIS_BRANCH"
