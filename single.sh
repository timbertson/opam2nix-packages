#!/usr/bin/env bash
set -eux
exec nix-build --no-out-link nix/single.nix --show-trace --argstr pkg "$@"
