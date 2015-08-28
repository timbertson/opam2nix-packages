let
    buildWithOverride = override:
    { opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([  ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "true";
      installPhase = "mkdir -p $out";
      name = "mirage-no-xen-1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-no-xen";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      unpackPhase = "true";
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
