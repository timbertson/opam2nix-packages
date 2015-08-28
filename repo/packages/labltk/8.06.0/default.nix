let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv, tcl-dev ? null,
        tk-dev ? null
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ tcl-dev tk-dev ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "labltk-8.06.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "labltk";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0r4pmwhks6abgb8fl3qqbr30xlabgl1p7p448h3fpr1ndjypv6bi";
        url = "https://forge.ocamlcore.org/frs/download.php/1455/labltk-8.06.0.tar.gz";
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
