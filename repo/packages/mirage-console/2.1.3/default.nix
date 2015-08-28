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
          mirage-types-lwt = opamSelection.mirage-types-lwt;
          mirage-unix = opamSelection.mirage-unix;
          mirage-xen = opamSelection.mirage-xen or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          shared-memory-ring = opamSelection.shared-memory-ring or null;
          xen-evtchn = opamSelection.xen-evtchn or null;
          xen-gnt = opamSelection.xen-gnt or null;
          xenstore = opamSelection.xenstore or null;
          xenstore_transport = opamSelection.xenstore_transport or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-console-2.1.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-console";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "01kg742zjlv1ifm9rxaqk6yar35hjsr4g2h0w6cw46jgyjqmgpm6";
        url = "https://github.com/mirage/mirage-console/archive/v2.1.3.tar.gz";
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
