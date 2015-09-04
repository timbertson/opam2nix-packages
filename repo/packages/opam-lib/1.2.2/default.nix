let
    buildWithOverride = override:
    { curl, fetchurl, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ curl ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          cmdliner = opamSelection.cmdliner;
          cudf = opamSelection.cudf;
          dose = opamSelection.dose;
          jsonm = opamSelection.jsonm;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ocamlgraph = opamSelection.ocamlgraph;
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
      name = "opam-lib-1.2.2";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "opam-lib";
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
        sha256 = "0sp3f54f27pfzy27gz72nsn37f9fj2z5x24x06xfrppqdzghajiy";
        url = "https://github.com/ocaml/opam/archive/1.2.2.tar.gz";
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
