let
    buildWithOverride = override:
    { opam2nix, opamSelection, pkg-config ? null, pkgconfig ? null, pkgs,
        stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ pkg-config pkgconfig ]++(lib.attrValues opamDeps));
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
      name = "conf-pkg-config-1.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "conf-pkg-config";
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
