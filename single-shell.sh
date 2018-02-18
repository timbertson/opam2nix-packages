#!/usr/bin/env bash
set -eux
exec nix-shell --no-out-link nix/single.nix --show-trace --argstr pkg "$1" --argstr shell "$2"
