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
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      ctypes = opamSelection.ctypes;
      fmt = opamSelection.fmt;
      lambda-term = opamSelection.lambda-term;
      lwt = opamSelection.lwt;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      stringext = opamSelection.stringext;
      unix-errno = opamSelection.unix-errno;
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
  name = "protocol-9p-0.5.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "protocol-9p";
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
    sha256 = "1bdz525i8aabvqdckyczqk94jmvvc9cr4b8bwky2sxm7s0xr390l";
    url = "https://github.com/mirage/ocaml-9p/archive/v0.5.0.tar.gz";
  };
}

