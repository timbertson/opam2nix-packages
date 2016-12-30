#!/bin/bash
set -eu
pushd keys
	openssl aes-256-cbc -K "$encrypted_d5f56ec82e6d_key" -iv "$encrypted_d5f56ec82e6d_iv" -in "archive.tgz.enc" -out "archive.tgz" -d
	tar xzf archive.tgz
popd
