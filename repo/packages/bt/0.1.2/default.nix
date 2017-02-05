world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bitstring = opamSelection.bitstring;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      cryptokit = opamSelection.cryptokit;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      qcheck = opamSelection.qcheck;
      ssl = opamSelection.ssl;
      uri = opamSelection.uri;
      zarith = opamSelection.zarith;
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
  name = "bt-0.1.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "bt";
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
    sha256 = "168jmkxfbjx772cwgn9ihqdr2x8nbjwsf85m4r2d207j5v0m4krx";
    url = "https://github.com/nojb/ocaml-bt/archive/v0.1.2.tar.gz";
  };
}

