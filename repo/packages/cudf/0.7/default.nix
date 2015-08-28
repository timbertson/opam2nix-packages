let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, perl ? null, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ perl ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          camlp4 = opamSelection.camlp4;
          extlib = opamSelection.extlib or null;
          extlib-compat = opamSelection.extlib-compat or null;
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
      name = "cudf-0.7";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "cudf";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "00d76305h8yhzjpjmaq2jadnr5kx290spaqk6lzwgfhbfgnskj4j";
        url = "https://gforge.inria.fr/frs/download.php/33593/cudf-0.7.tar.gz";
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
