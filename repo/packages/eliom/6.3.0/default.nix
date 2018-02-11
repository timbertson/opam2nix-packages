world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      dbm = opamSelection.dbm or null;
      deriving = opamSelection.deriving;
      ipaddr = opamSelection.ipaddr;
      js_of_ocaml = opamSelection.js_of_ocaml;
      js_of_ocaml-lwt = opamSelection.js_of_ocaml-lwt;
      js_of_ocaml-ocamlbuild = opamSelection.js_of_ocaml-ocamlbuild;
      js_of_ocaml-ppx = opamSelection.js_of_ocaml-ppx;
      js_of_ocaml-ppx_deriving_json = opamSelection.js_of_ocaml-ppx_deriving_json or null;
      js_of_ocaml-tyxml = opamSelection.js_of_ocaml-tyxml;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocsigenserver = opamSelection.ocsigenserver;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_tools = opamSelection.ppx_tools;
      reactiveData = opamSelection.reactiveData;
      sqlite3 = opamSelection.sqlite3 or null;
      tyxml = opamSelection.tyxml;
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
  name = "eliom-6.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "eliom";
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
    sha256 = "137hgdzv9fwkzf6xdksqy437lrf8xvrycf5jwc3z4cmpsigs6x7v";
    url = "https://github.com/ocsigen/eliom/archive/6.3.0.tar.gz";
  };
}

