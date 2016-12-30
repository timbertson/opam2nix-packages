#!/bin/bash
set -eux
function export_archive() {
	git archive HEAD --format=tar.gz --prefix="git-export/" > nix/local.tgz
}

export_archive
pushd opam2nix
	export_archive
popd
nix-shell --pure --run script/travis-update.sh
