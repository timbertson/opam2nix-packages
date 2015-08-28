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
          ipaddr = opamSelection.ipaddr;
          lwt = opamSelection.lwt;
          mirage-profile = opamSelection.mirage-profile;
          mirage-types = opamSelection.mirage-types;
          mirage-xen = opamSelection.mirage-xen;
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
      name = "mirage-net-xen-1.4.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-net-xen";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0ywrgcsd3yn5xk7604m8xwav6mix9i7jw7q36kybxmnhaia0wrgd";
        url = "https://github.com/mirage/mirage-net-xen/archive/v1.4.1.tar.gz";
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
