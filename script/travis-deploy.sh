#!/bin/bash
set -eu

eval "$(ssh-agent -s)"
script/travis-decrypt.sh

set -x

chmod 600 keys/*.key
ssh-add keys/*.key

PUSH_ARGS=""
if [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then
	echo "(not pushing changes)"
	PUSH_ARGS="-n"
fi

function push() {
	for dir in "$@"; do
		pushd "$dir"
			if [ -e .push ]; then
				git push $PUSH_ARGS
			else
				echo "No changes in $dir"
			fi
		popd
	done
}
