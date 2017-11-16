world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      cmdliner = opamSelection.cmdliner;
      cow = opamSelection.cow;
      cppo = opamSelection.cppo;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      rresult = opamSelection.rresult;
      type_conv = opamSelection.type_conv;
      xmlm = opamSelection.xmlm;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "rpc-1.9.51";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "rpc";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0k9qbhkpk6al73gfd7ylxpnmrlmwzbq4k1d2pj6pp5lqcrgz8va0";
    url = "https://github.com/mirage/ocaml-rpc/archive/v1.9.51.tar.gz";
  };
}

