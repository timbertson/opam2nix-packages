world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries or null;
      conf-r = opamSelection.conf-r;
      cpm = opamSelection.cpm or null;
      dolog = opamSelection.dolog or null;
      jbuilder = opamSelection.jbuilder;
      minicli = opamSelection.minicli or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      parmap = opamSelection.parmap or null;
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
  name = "orsvm_e1071-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "orsvm_e1071";
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
    sha256 = "0a7zg8921by7kkbicrdzgq01b21846dna2c17kgzaipkj8h21hh9";
    url = "https://github.com/UnixJunkie/orsvm-e1071/archive/v2.0.0.tar.gz";
  };
}

