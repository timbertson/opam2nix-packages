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
      base-unix = opamSelection.base-unix;
      conf-which = opamSelection.conf-which;
      fmt = opamSelection.fmt;
      fpath = opamSelection.fpath;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      rresult = opamSelection.rresult;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "bos-0.1.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bos";
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
    sha256 = "1smr951gkg2zzzwxffdw8p0sy9nrbsm91shz120l7h3v55wdqxw6";
    url = "http://erratique.ch/software/bos/releases/bos-0.1.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

