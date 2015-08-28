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
          channel = opamSelection.channel;
          cohttp = opamSelection.cohttp;
          lwt = opamSelection.lwt;
          mirage-conduit = opamSelection.mirage-conduit;
          mirage-types-lwt = opamSelection.mirage-types-lwt;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          sexplib = opamSelection.sexplib;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-http-2.5.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-http";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "057ss3cxj6793434nq6wjcs9iln3vwimfizip2bqlsd2djkwn13h";
        url = "https://github.com/mirage/mirage-http/archive/v2.5.0.tar.gz";
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
