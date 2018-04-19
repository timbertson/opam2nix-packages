from __future__ import print_function
import sys, os, json
from subprocess import *

def opam2nix_expr():
	return '''let
		src = fetchgit %(fetchgit_src)s;
		opam2nixSrc = fetchgit %(fetchgit_opam2nix)s;
	in
	callPackage "${src}/nix" {
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	}''' % {
			'fetchgit_src': fetchgit('src.json'),
			'fetchgit_opam2nix': fetchgit('src-opam2nix.json'),
		}

def nix_of_json(j):
	source_text = json.dumps(j, indent=2, separators=(';',' = ')).rstrip('}\n') + ';\n}'
	return '\n\t\t'.join([line.replace('  ', '\t') for line in source_text.splitlines()])

def fetchgit(filename):
	check_call(['gup', '-u', filename])
	with open(filename) as f:
		params = json.load(f)
	return nix_of_json(params['fetch']['args'])

check_call(['gup', '-u', os.path.join(os.path.dirname(__file__), 'common.py')])

def write_target(contents):
	dest, target = sys.argv[1:]
	with open(dest, 'w') as dest:
		dest.write(contents)
