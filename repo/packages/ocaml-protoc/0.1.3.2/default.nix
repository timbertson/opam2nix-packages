world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving_protobuf = opamSelection.ppx_deriving_protobuf;
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
  name = "ocaml-protoc-0.1.3.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocaml-protoc";
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
    sha256 = "0iy3kj076g7dq6zghrzk6lcrf2vy5s0rf511shvi1nfd0wr0jbiv";
    url = "https://github.com/mransan/ocaml-protoc/archive/0.1.3.2.tar.gz";
  };
}

