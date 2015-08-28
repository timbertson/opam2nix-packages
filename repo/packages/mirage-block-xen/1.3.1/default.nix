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
          cmdliner = opamSelection.cmdliner;
          cstruct = opamSelection.cstruct;
          io-page = opamSelection.io-page;
          ipaddr = opamSelection.ipaddr;
          lwt = opamSelection.lwt;
          mirage-types = opamSelection.mirage-types;
          mirage-xen = opamSelection.mirage-xen;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          shared-memory-ring = opamSelection.shared-memory-ring;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-block-xen-1.3.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-block-xen";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0y7zigmma5qxd0csc2cbr23kz83wkvh1xdzrqshgdx5br38inppw";
        url = "https://github.com/mirage/mirage-block-xen/archive/v1.3.1.tar.gz";
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
