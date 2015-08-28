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
          async = opamSelection.async or null;
          base-bytes = opamSelection.base-bytes;
          base-unix = opamSelection.base-unix or null;
          base64 = opamSelection.base64;
          cmdliner = opamSelection.cmdliner;
          cstruct = opamSelection.cstruct;
          ipaddr = opamSelection.ipaddr;
          lwt = opamSelection.lwt;
          mirage-profile = opamSelection.mirage-profile;
          mirage-types = opamSelection.mirage-types or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          re = opamSelection.re;
          uri = opamSelection.uri;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "dns-0.15.3";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "dns";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "06cn5b8v76p4l3axr7caww0bm24js350dp2jsnl6yyqs3pjn24yc";
        url = "https://github.com/mirage/ocaml-dns/archive/v0.15.3.tar.gz";
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
