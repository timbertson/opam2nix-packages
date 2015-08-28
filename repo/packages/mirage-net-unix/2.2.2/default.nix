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
          io-page = opamSelection.io-page;
          lwt = opamSelection.lwt;
          mirage-types = opamSelection.mirage-types;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ounit = opamSelection.ounit;
          tuntap = opamSelection.tuntap;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-net-unix-2.2.2";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-net-unix";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0zdr49809c9jyfjr705i72cxmmpy84hc6fa6z0mr1ysxfppz7s0h";
        url = "https://github.com/mirage/mirage-net-unix/archive/v2.2.2.tar.gz";
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
