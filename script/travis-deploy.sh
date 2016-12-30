#!/bin/bash
set -eux

eval "$(ssh-agent -s)"
chmod 600 keys/*.key
ssh-add keys/*.key

git config user.name 'travis-ci';
git config user.email 'travis-ci@gfxmonk.net';

PUSH_ARGS=""
if [ "$TRAVIS_EVENT_TYPE" == "cron" ]; then
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
