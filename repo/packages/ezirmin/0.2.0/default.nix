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
      irmin-watcher = opamSelection.irmin-watcher;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_jane = opamSelection.ppx_jane;
      ptime = opamSelection.ptime;
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
  name = "ezirmin-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ezirmin";
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
    sha256 = "17a71w1v6pw9i2cr96fjvd4bsisjrhqlx3hyb7bk5xjmp04yvs0x";
    url = "https://github.com/kayceesrk/ezirmin/releases/download/0.2.0/ezirmin-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

