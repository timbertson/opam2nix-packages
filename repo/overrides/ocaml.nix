# A special snowflake override for ocaml, to interop with opam+findlib.
# Findlib's opam package gets away with it by shadowing the `ocaml` binary on $PATH,
# but that won't work in a nix build environment
{ makeWrapper, lib }: impl:
lib.overrideDerivation impl (orig: {
	buildInputs = (orig.buildInputs or []) ++ [ makeWrapper ];
	postInstall = (orig.postInstall or "") + ''
		mv $out/bin/ocaml $out/bin/.ocaml.wrapped
		cat > $out/bin/ocaml <<EOF
#!/bin/bash
if test -n "\$OCAML_TOPLEVEL_PATH"; then
	exec "$out/bin/.ocaml.wrapped" -I "\$OCAML_TOPLEVEL_PATH" "\$@"
else
	exec "$out/bin/.ocaml.wrapped" "\$@"
fi
EOF
		chmod a+x $out/bin/ocaml
	'';
})
