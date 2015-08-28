let
    buildWithOverride = override:
    { fetchurl, libxen-dev ? null, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ libxen-dev ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          camlp4 = opamSelection.camlp4;
          cmdliner = opamSelection.cmdliner;
          lwt = opamSelection.lwt;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ounit = opamSelection.ounit;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "xen-evtchn-1.0.6";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "xen-evtchn";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1vgm2w7ds22ljsl31kblvbsc9l1nzrn2kx6rpp3qxf74wqb74ygp";
        url = "https://github.com/mirage/ocaml-evtchn/archive/v1.0.6.tar.gz";
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
