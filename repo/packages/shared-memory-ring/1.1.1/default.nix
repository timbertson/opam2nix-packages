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
          cstruct = opamSelection.cstruct;
          lwt = opamSelection.lwt;
          mirage-profile = opamSelection.mirage-profile;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
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
      name = "shared-memory-ring-1.1.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "shared-memory-ring";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0bdmgrsbrh5c3g973qv8bv0h5c1sjpyrk74cp2270phj1gh4zwkl";
        url = "https://github.com/mirage/shared-memory-ring/archive/1.1.1.tar.gz";
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
