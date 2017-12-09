#!/usr/bin/env bash
set -eux
if [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then
	: not a cron build, ignoring
	exit 0
fi

function export_archive() {
	git archive HEAD --format=tar.gz --prefix="git-export/" > nix/local.tgz
}

export_archive
pushd opam2nix
	export_archive
popd
nix-shell --arg ci true --run script/travis-update.sh
