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
          channel = opamSelection.channel;
          cstruct = opamSelection.cstruct;
          ipaddr = opamSelection.ipaddr;
          lwt = opamSelection.lwt;
          mirage-clock-unix = opamSelection.mirage-clock-unix;
          mirage-console = opamSelection.mirage-console;
          mirage-net-unix = opamSelection.mirage-net-unix;
          mirage-profile = opamSelection.mirage-profile;
          mirage-types = opamSelection.mirage-types;
          mirage-unix = opamSelection.mirage-unix;
          mirage-xen = opamSelection.mirage-xen or null;
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
      name = "tcpip-2.6.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "tcpip";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1answ1a5rq99qqm8q02w2c4v0xi5a7xnw1czk88yf9b5pfx2f3km";
        url = "https://github.com/mirage/mirage-tcpip/archive/v2.6.0.tar.gz";
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
