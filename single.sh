#!/usr/bin/env bash
exec nix-build --no-out-link nix/single.nix --show-trace --argstr pkg "$@"
