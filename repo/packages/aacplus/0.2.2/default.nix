world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([
        (pkgs."https://gist.githubusercontent.com/avsm/11409198/raw/8a67c518ad9e030725bb67f25119940eb8da2fa4/install-aacplus.sh" or null)
        ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "aacplus-0.2.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "aacplus";
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
    sha256 = "0qvcvz1x7b8l7h4l7ifqdjnv5jh93n5y4c69lvn2h9hbb3nbngpb";
    url = "https://github.com/savonet/ocaml-aacplus/releases/download/0.2.2/ocaml-aacplus-0.2.2.tar.gz";
  };
}

