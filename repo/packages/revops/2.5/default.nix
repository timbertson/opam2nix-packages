world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      containers = opamSelection.containers;
      merlin-of-pds = opamSelection.merlin-of-pds;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      pds = opamSelection.pds;
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
  name = "revops-2.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "revops";
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
    sha256 = "1c7jh17ny22yf956x9alcds2pbh5i9y8siqfcv1q5lkvj8g60vgn";
    url = "https://bitbucket.org/mimirops/revops/get/2.5.tar.gz";
  };
}

