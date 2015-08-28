let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([  ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "menhir-20140422";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "menhir";
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
        sha256 = "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d";
        url = "http://cristal.inria.fr/~fpottier/menhir/menhir-20140422.tar.gz";
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
