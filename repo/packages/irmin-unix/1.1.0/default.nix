world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      git-unix = opamSelection.git-unix;
      irmin = opamSelection.irmin;
      irmin-git = opamSelection.irmin-git;
      irmin-http = opamSelection.irmin-http;
      irmin-watcher = opamSelection.irmin-watcher;
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
  name = "irmin-unix-1.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin-unix";
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
    sha256 = "1x4kcvf7v4rfbnz2kbpm6fslmyqcgpnf68zvxwxm9al2kc1wk764";
    url = "https://github.com/mirage/irmin/releases/download/1.1.0/irmin-1.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

