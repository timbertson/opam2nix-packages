#!/usr/bin/env bash
set -eux

git config user.name 'travis-ci';
git config user.email 'travis-ci@gfxmonk.net';

mkdir -p opam-repository
pushd opam-repository
	git clone git://github.com/ocaml/opam-repository.git
popd

rm -f .push
gup repo/packages
if ! git diff --quiet --exit-code; then
	git add -u repo/digest.json nix/
	git commit -m "Automated package update";
	gup nix/all
	git commit -u -m "Bump release nix expressions" nix
	touch .push
fi
