let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv, time ? null
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ time ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          async = opamSelection.async or null;
          camlp4 = opamSelection.camlp4 or null;
          lwt = opamSelection.lwt or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ocplib-endian = opamSelection.ocplib-endian;
          sexplib = opamSelection.sexplib;
          type_conv = opamSelection.type_conv;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "cstruct-1.7.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "cstruct";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1bfa83080r7hha84c3qwl138aacf7g0p39wcff10d826jx5s2dlx";
        url = "https://github.com/mirage/ocaml-cstruct/archive/v1.7.0.tar.gz";
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
