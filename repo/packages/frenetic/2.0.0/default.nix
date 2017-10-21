world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      core = opamSelection.core;
      cstruct = opamSelection.cstruct or null;
      fieldslib = opamSelection.fieldslib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      openflow = opamSelection.openflow;
      ounit = opamSelection.ounit;
      packet = opamSelection.packet or null;
      quickcheck = opamSelection.quickcheck or null;
      sexplib = opamSelection.sexplib;
      topology = opamSelection.topology;
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
  name = "frenetic-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "frenetic";
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
    sha256 = "0fafb1h61mdfmj52pnl7cfir00mb1npabaxnzy3wrjr327xgpxpn";
    url = "https://github.com/frenetic-lang/frenetic/archive/v2.0.0.tar.gz";
  };
}

