#!/bin/bash
set -eu
"$(dirname "$0")/packages.gup" --update "$@"
