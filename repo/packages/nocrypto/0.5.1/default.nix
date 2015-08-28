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
          cstruct = opamSelection.cstruct;
          lwt = opamSelection.lwt or null;
          mirage-entropy-xen = opamSelection.mirage-entropy-xen or null;
          mirage-no-xen = opamSelection.mirage-no-xen or null;
          mirage-xen = opamSelection.mirage-xen or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          sexplib = opamSelection.sexplib;
          type_conv = opamSelection.type_conv;
          zarith = opamSelection.zarith;
          zarith-xen = opamSelection.zarith-xen or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "nocrypto-0.5.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "nocrypto";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "132bndb83isw35529mdjqb92jc58x4d7kvj7x0i3lwasyaq774b0";
        url = "https://github.com/mirleft/ocaml-nocrypto/archive/0.5.1.tar.gz";
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
