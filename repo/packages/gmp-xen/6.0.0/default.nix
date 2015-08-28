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
          mirage-xen-posix = opamSelection.mirage-xen-posix;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "gmp-xen-6.0.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "gmp-xen";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0r5pp27cy7ch3dg5v0rsny8bib1zfvrza6027g2mp5f6v8pd6mli";
        url = "https://gmplib.org/download/gmp/gmp-6.0.0a.tar.xz";
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
