#!/usr/bin/env bash
set -eux
pkg="$1"
shift
exec nix-pin shell --no-out-link --path nix/default.nix --show-trace -A opamPackages.4_06."$pkg" "$@"
