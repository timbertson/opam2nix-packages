world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libfuse-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bigarray = opamSelection.base-bigarray;
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      camlidl = opamSelection.camlidl;
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
  name = "ocamlfuse-2.7.1-cvs3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocamlfuse";
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
    sha256 = "18g6nidfdiwjw4l8iw7z8l7jhssfgfb6vsc8n8f7yqskvrhrc0jw";
    url = "https://forge.ocamlcore.org/frs/download.php/1662/ocamlfuse-2.7.1-cvs3.tar.gz";
  };
}

