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
          cmdliner = opamSelection.cmdliner;
          cstruct = opamSelection.cstruct;
          io-page = opamSelection.io-page;
          lwt = opamSelection.lwt;
          mirage-block-unix = opamSelection.mirage-block-unix;
          mirage-types = opamSelection.mirage-types;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ounit = opamSelection.ounit;
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
      name = "fat-filesystem-0.10.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "fat-filesystem";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "101kbcm49fxzmziw4wx3n5v9qrn8sdbrs5disxhjlds0zy42ms2z";
        url = "https://github.com/mirage/ocaml-fat/archive/v0.10.3.tar.gz";
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
