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
          camlp4 = opamSelection.camlp4;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          type_conv = opamSelection.type_conv or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "sexplib-111.25.00";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "sexplib";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0qh0zqp5nakqpmmhh4x7cg03vqj3j2bj4zj0nqdlksai188p9ila";
        url = "https://ocaml.janestreet.com/ocaml-core/111.25.00/individual/sexplib-111.25.00.tar.gz";
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
