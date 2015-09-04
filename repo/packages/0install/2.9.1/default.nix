let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv, unzip ? null
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ unzip ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          extlib = opamSelection.extlib;
          lablgtk = opamSelection.lablgtk or null;
          lwt = opamSelection.lwt;
          obus = opamSelection.obus or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind or null;
          ocurl = opamSelection.ocurl;
          ounit = opamSelection.ounit;
          react = opamSelection.react;
          sha = opamSelection.sha;
          xmlm = opamSelection.xmlm;
          yojson = opamSelection.yojson;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "0install-2.9.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "0install";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0c8qj25p9r3glihxbpla1c3k06lqbcgwwdsba83jhw9g6yricfyf";
        url = "https://downloads.sf.net/project/zero-install/0install/2.9.1/0install-2.9.1.tar.bz2";
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
