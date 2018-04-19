#!/usr/bin/env bash
set -eux

git config user.name 'travis-ci';
git config user.email 'travis-ci@gfxmonk.net';

pushd opam-repository
	rm -f .push
	git fetch git://github.com/ocaml/opam-repository.git
	if ! git diff --quiet --exit-code FETCH_HEAD; then
		git merge --no-edit FETCH_HEAD
		touch .push
	fi
popd


rm -f .push
./repo/packages.gup --update
if ! git diff --quiet --exit-code; then
	git add --all opam-repository repo/packages
	git commit -m "Automated package update";
	gup nix/all
	git commit -m "Bump release nix expressions" nix
	touch .push
fi
