world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      cow = opamSelection.cow;
      crunch = opamSelection.crunch;
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      iocaml-kernel = opamSelection.iocaml-kernel;
      iocamljs-kernel = opamSelection.iocamljs-kernel;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      uuidm = opamSelection.uuidm;
      websocket = opamSelection.websocket;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "iocaml-0.4.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "iocaml";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1dh7aa2zm3f2bssq8mkfyz052w910400rik8wryybrwf235ddrbg";
    url = "https://github.com/andrewray/iocamlserver/archive/v0.4.9.tar.gz";
  };
}

