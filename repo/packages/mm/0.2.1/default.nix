world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alsa = opamSelection.alsa or null;
      ao = opamSelection.ao or null;
      gstreamer = opamSelection.gstreamer or null;
      mad = opamSelection.mad or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlsdl = opamSelection.ocamlsdl or null;
      ogg = opamSelection.ogg or null;
      pulseaudio = opamSelection.pulseaudio or null;
      theora = opamSelection.theora or null;
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
  name = "mm-0.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mm";
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
    sha256 = "0b85l3jsvj8g76gdfy8r4fgcirzcphyx45llj19zrvvj01slcng5";
    url = "http://downloads.sourceforge.net/project/savonet/ocaml-mm/0.2.1/ocaml-mm-0.2.1.tar.gz";
  };
}

