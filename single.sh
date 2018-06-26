#!/usr/bin/env bash
pkg="$1"
shift
exec nix-pin build --no-out-link --path nix/default.nix --show-trace -A opamPackages.4_05."$pkg" "$@"
