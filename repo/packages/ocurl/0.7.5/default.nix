let
    buildWithOverride = override:
    { fetchurl, libcurl-devel ? null, libcurl4-gnutls-dev ? null, opam2nix,
        opamSelection, openssl-devel ? null, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([ libcurl-devel libcurl4-gnutls-dev openssl-devel ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          lwt = opamSelection.lwt or null;
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
      name = "ocurl-0.7.5";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "ocurl";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1zvcbx1jb3vcbgvaan7rx1zak4h1idqcjyik510mnlh904pjlhx6";
        url = "http://ygrek.org.ua/p/release/ocurl/ocurl-0.7.5.tar.gz";
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
