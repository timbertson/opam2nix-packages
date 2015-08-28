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
          async = opamSelection.async or null;
          base-bytes = opamSelection.base-bytes;
          base64 = opamSelection.base64;
          cmdliner = opamSelection.cmdliner;
          conduit = opamSelection.conduit;
          fieldslib = opamSelection.fieldslib;
          js_of_ocaml = opamSelection.js_of_ocaml or null;
          lwt = opamSelection.lwt or null;
          magic-mime = opamSelection.magic-mime;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          re = opamSelection.re;
          sexplib = opamSelection.sexplib;
          stringext = opamSelection.stringext;
          uri = opamSelection.uri;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "cohttp-0.17.2";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "cohttp";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0hji7a91j29kr3apz3rhpv8q1k4pqgc5wjbxcdydkh3znhbsx4gf";
        url = "https://github.com/mirage/ocaml-cohttp/archive/v0.17.2.tar.gz";
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
