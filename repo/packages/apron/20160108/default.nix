world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlidl = opamSelection.camlidl;
      conf-ppl = opamSelection.conf-ppl or null;
      mlgmpidl = opamSelection.mlgmpidl;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "apron-20160108";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "apron";
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
    sha256 = "13m183yxxwx2vs0s3lyjnsdhixnvvkv5lyiqswhd32ifk3j192mj";
    url = "http://apron.gforge.inria.fr/apron-20160108.tar.gz";
  };
}

