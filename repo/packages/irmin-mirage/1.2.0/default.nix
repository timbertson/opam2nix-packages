world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      git-mirage = opamSelection.git-mirage;
      irmin = opamSelection.irmin;
      irmin-git = opamSelection.irmin-git;
      irmin-mem = opamSelection.irmin-mem;
      jbuilder = opamSelection.jbuilder;
      mirage-clock = opamSelection.mirage-clock;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ptime = opamSelection.ptime;
      result = opamSelection.result;
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
  name = "irmin-mirage-1.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin-mirage";
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
    sha256 = "10aa4lzw3k0gv72p13733mqnljm68abbi816hw9b9r6f1di4hhw6";
    url = "https://github.com/mirage/irmin/releases/download/1.2.0/irmin-1.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

