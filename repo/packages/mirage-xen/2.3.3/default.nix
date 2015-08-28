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
          conf-pkg-config = opamSelection.conf-pkg-config;
          cstruct = opamSelection.cstruct;
          io-page = opamSelection.io-page;
          lwt = opamSelection.lwt;
          mirage-clock-xen = opamSelection.mirage-clock-xen;
          mirage-profile = opamSelection.mirage-profile;
          mirage-xen-minios = opamSelection.mirage-xen-minios;
          mirage-xen-ocaml = opamSelection.mirage-xen-ocaml;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          shared-memory-ring = opamSelection.shared-memory-ring;
          xen-evtchn = opamSelection.xen-evtchn;
          xen-gnt = opamSelection.xen-gnt;
          xenstore = opamSelection.xenstore;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-xen-2.3.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-xen";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0s33fmbl2mn0am8rx0l0q12dgjw3sqwfqvmcb2fqhpz72i3s29gi";
        url = "https://github.com/mirage/mirage-platform/archive/v2.3.3.tar.gz";
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
