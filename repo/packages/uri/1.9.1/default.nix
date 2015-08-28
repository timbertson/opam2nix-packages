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
          base-bytes = opamSelection.base-bytes;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          re = opamSelection.re;
          sexplib = opamSelection.sexplib;
          stringext = opamSelection.stringext;
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
      name = "uri-1.9.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "uri";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "00j40g7clnslalvdwz12m3l0bak9n6fi2j3dapmyqrxza0qzbsg7";
        url = "https://github.com/mirage/ocaml-uri/archive/v1.9.1.tar.gz";
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
