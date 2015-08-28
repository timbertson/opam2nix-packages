let
    buildWithOverride = override:
    { fetchurl, libxen-dev ? null, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ libxen-dev ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          cmdliner = opamSelection.cmdliner;
          cstruct = opamSelection.cstruct;
          io-page = opamSelection.io-page;
          lwt = opamSelection.lwt;
          mirage-profile = opamSelection.mirage-profile;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind or null;
          ounit = opamSelection.ounit;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "xen-gnt-2.2.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "xen-gnt";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0a3d0zzbcias5z8qzgjvxrz6zczkas90b52crz0pz1sg90ps3wa7";
        url = "https://github.com/mirage/ocaml-gnt/archive/v2.2.0.tar.gz";
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
