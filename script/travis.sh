#!/usr/bin/env bash
set -eux
function run_scheduled() {
	nix-shell --arg ci true --run script/travis-update.sh
}

function run_ci() {
	./examples/all.gup
}

if [ "${TRAVIS_EVENT_TYPE:-}" = "cron" ]; then
	run_scheduled
else
	run_ci
fi

