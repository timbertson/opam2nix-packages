world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      base-bytes = opamSelection.base-bytes;
      base-unix = opamSelection.base-unix;
      camlp4 = opamSelection.camlp4;
      ctypes = opamSelection.ctypes or null;
      ctypes-foreign = opamSelection.ctypes-foreign or null;
      js_of_ocaml = opamSelection.js_of_ocaml;
      js_of_ocaml-camlp4 = opamSelection.js_of_ocaml-camlp4;
      lwt = opamSelection.lwt or null;
      num = opamSelection.num;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "hardcaml-1.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hardcaml";
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
    sha256 = "0nyhydg4vlxf1jxdcpg9ijgbx70vp8s9qd5s1dfahvlmvwk1cbzk";
    url = "https://github.com/ujamjar/hardcaml/archive/v1.2.0.tar.gz";
  };
}

