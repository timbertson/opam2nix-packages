let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, perl, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ perl ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          conf-gmp = opamSelection.conf-gmp;
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
      name = "zarith-1.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "zarith";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1mx3nxcn5h33qhx4gbg0hgvvydwlwdvdhqcnvfwnmf9jy3b8frll";
        url = "https://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz";
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
