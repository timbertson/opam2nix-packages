#!/usr/bin/env bash
set -eux
exec nix-pin build --no-out-link --path nix/single.nix --show-trace --argstr pkg "$@"
