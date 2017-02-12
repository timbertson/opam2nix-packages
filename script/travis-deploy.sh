#!/bin/bash
set -eu

eval "$(ssh-agent -s)"
script/travis-decrypt.sh

set -x

chmod 600 keys/*.key
ssh-add keys/*.key

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

push opam-repository git@github.com:timbertson/opam-repository.git HEAD:master
push . git@github.com:timbertson/opam-repository.git HEAD:"$TRAVIS_BRANCH"
