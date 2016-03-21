world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cohttp = opamSelection.cohttp;
      js_of_ocaml = opamSelection.js_of_ocaml;
      lwt = opamSelection.lwt;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      websocket = opamSelection.websocket;
      xtmpl = opamSelection.xtmpl;
      yojson = opamSelection.yojson;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ojs-base-0.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ojs-base";
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
    sha256 = "0padcrb2z8id8w1z3mrlpxa5hihc2lx0qm7jjh4h6yjcz3gnkaa8";
    url = "http://zoggy.github.com/ojs-base/ojs-base-0.4.0.tar.gz";
  };
}

