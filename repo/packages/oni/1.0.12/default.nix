world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      omake = opamSelection.omake;
      ounit = opamSelection.ounit;
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
  name = "oni-1.0.12";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "oni";
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
    sha256 = "1lwsap8516xmk3jm9n0c9klr7gxd4a6bx64p1m0qvsz39dblacz2";
    url = "https://bitbucket.org/jhw/oni/downloads/oni.1.0.12.tar.xz";
  };
}

