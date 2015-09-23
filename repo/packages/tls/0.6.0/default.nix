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
          lwt = opamSelection.lwt or null;
          mirage-types-lwt = opamSelection.mirage-types-lwt or null;
          nocrypto = opamSelection.nocrypto;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          sexplib = opamSelection.sexplib;
          type_conv = opamSelection.type_conv;
          x509 = opamSelection.x509;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "tls-0.6.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "tls";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "13znsf1fi68xbv2byxr66lm5xvz2qn53zlys8p78qaygv0js7nqj";
        url = "https://github.com/mirleft/ocaml-tls/archive/0.6.0.tar.gz";
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
