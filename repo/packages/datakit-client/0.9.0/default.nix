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
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      fmt = opamSelection.fmt;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      protocol-9p = opamSelection.protocol-9p;
      rresult = opamSelection.rresult;
      topkg = opamSelection.topkg;
      uri = opamSelection.uri;
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
  name = "datakit-client-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-client";
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
    sha256 = "08q2kifg66bh8fnf4971gvlw5c9r78zvq6l9r7x0ng1q9ylkx7d2";
    url = "https://github.com/docker/datakit/releases/download/0.9.0/datakit-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

