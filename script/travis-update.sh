#!/usr/bin/env bash
set -eux

git config user.name 'travis-ci';
git config user.email 'travis-ci@gfxmonk.net';

if [ ! -e opam-repository ]; then
	git clone git://github.com/ocaml/opam-repository.git
fi

rm -f .push
gup repo/packages nix/release/src-opam-repository.json
if ! git diff --quiet --exit-code; then
	git add -u repo nix/
	git commit -m "Automated package update";
	gup nix/all
	git commit -u -m "Bump release nix expressions" nix
	touch .push
fi
