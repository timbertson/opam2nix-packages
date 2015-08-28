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
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          type_conv = opamSelection.type_conv;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "fieldslib-109.20.03";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "fieldslib";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1dkzk0wf26rhvji80dz1r56dp6x9zqrnp87wldd4pj56jli94vir";
        url = "https://ocaml.janestreet.com/ocaml-core/109.20.00/individual/fieldslib-109.20.03.tar.gz";
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
