world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      gen = opamSelection.gen;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sedlex = opamSelection.sedlex;
      utop = opamSelection.utop or null;
      uucp = opamSelection.uucp;
      uunf = opamSelection.uunf;
      uutf = opamSelection.uutf;
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
  name = "m17n-1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "m17n";
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
    sha256 = "149jwlhwdd5sdwc2fvm917ngd0nla0hd7v62xc8h329y2jq3cj5l";
    url = "https://github.com/whitequark/ocaml-m17n/archive/v1.0.tar.gz";
  };
}

