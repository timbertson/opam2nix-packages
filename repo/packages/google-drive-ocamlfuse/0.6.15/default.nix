world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      camlidl = opamSelection.camlidl;
      gapi-ocaml = opamSelection.gapi-ocaml;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlfuse = opamSelection.ocamlfuse;
      sqlite3 = opamSelection.sqlite3;
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
  name = "google-drive-ocamlfuse-0.6.15";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "google-drive-ocamlfuse";
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
    sha256 = "0q63lagr47lvhg98zvvgwz56r93nhz9a7kjxrnfr8jmcc6vxi7h9";
    url = "https://github.com/astrada/google-drive-ocamlfuse/archive/v0.6.15.tar.gz";
  };
}

