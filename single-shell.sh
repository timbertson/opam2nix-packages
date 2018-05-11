#!/usr/bin/env bash
set -eux
exec nix-pin shell shell --no-out-link nix/single.nix --show-trace --argstr pkg "$1" --argstr shell "$2"
