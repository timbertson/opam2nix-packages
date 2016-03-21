world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.blas-devel or null) (pkgs.lapack-devel or null)
        (pkgs.libblas-dev or null) (pkgs.liblapack-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bigarray = opamSelection.base-bigarray;
      base-bytes = opamSelection.base-bytes;
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
  name = "lacaml-7.2.6";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "lacaml";
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
    sha256 = "0z5bnyqf8aci64lb4rq7rbb84s9pi3hl4i6y3ik6nvhlxwcm6lmf";
    url = "https://github.com/mmottl/lacaml/releases/download/v7.2.6/lacaml-7.2.6.tar.gz";
  };
}

