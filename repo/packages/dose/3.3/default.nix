let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, perl, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ perl ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          cudf = opamSelection.cudf;
          extlib = opamSelection.extlib or null;
          extlib-compat = opamSelection.extlib-compat or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ocamlgraph = opamSelection.ocamlgraph;
          re = opamSelection.re;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "dose-3.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "dose";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "03k800zg0s8wh9skic99vq5b0gmshpvksa5v5ajb66x8n7lxmi4d";
        url = "https://gforge.inria.fr/frs/download.php/file/34277/dose3-3.3.tar.gz";
      };
    })
    
    ;
    identity = x: x;
    wrap = buildWithOverride:
    {
      impl = buildWithOverride identity;
      withOverride = override:
      wrap (additionalOverride:
      buildWithOverride (attrs:
      additionalOverride (override attrs)
      )
      )
      ;
    }
    ;
in
wrap buildWithOverride
