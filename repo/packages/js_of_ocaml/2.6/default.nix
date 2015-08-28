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
          base-no-ppx = opamSelection.base-no-ppx or null;
          base-unix = opamSelection.base-unix;
          base64 = opamSelection.base64;
          camlp4 = opamSelection.camlp4;
          cmdliner = opamSelection.cmdliner;
          cppo = opamSelection.cppo;
          deriving = opamSelection.deriving or null;
          lwt = opamSelection.lwt;
          menhir = opamSelection.menhir;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ppx_tools = opamSelection.ppx_tools or null;
          reactiveData = opamSelection.reactiveData or null;
          tyxml = opamSelection.tyxml or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "js_of_ocaml-2.6";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "js_of_ocaml";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0q34lrn70dvz41m78bwgriyq6dxk97g8gcyg80nvxii4jp86dw61";
        url = "https://github.com/ocsigen/js_of_ocaml/archive/2.6.tar.gz";
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
