#!/usr/bin/env bash
set -eux
function export_archive() {
	git archive HEAD --format=tar.gz --prefix="git-export/" > nix/local.tgz
}

function run_scheduled() {
	export_archive
	pushd opam2nix
		export_archive
	popd
	nix-shell --arg ci true --run script/travis-update.sh
}

function run_ci() {
	cd examples
	find * -maxdepth 0 -type d | while read example; do
		pushd "$example"
			nix-build --no-out-link --show-trace
		popd
	done
}

if [ "${TRAVIS_EVENT_TYPE:-}" = "cron" ]; then
	run_scheduled
else
	run_ci
fi

