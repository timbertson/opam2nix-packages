#!/bin/bash
set -eu
gup="$(nix-build --show-trace --no-out-link -A gup '<nixpkgs>')"
[ -n "$gup" ] || exit 1
"$gup/bin/gup" all

