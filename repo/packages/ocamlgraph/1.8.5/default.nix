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
          conf-gnomecanvas = opamSelection.conf-gnomecanvas or null;
          lablgtk = opamSelection.lablgtk or null;
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
      name = "ocamlgraph-1.8.5";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "ocamlgraph";
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
        sha256 = "0bxqxzd5sd7siz57vhzb8bmiz1ddhgdv49gcsmwwfmd16mj4cryi";
        url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.5.tar.gz";
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
