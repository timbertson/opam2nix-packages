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
  name = "mm-0.3.1";
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
    sha256 = "16fr0pz84s5ksz1bli1cz8h0d85wq9r7xd3s2psrn6mmcr9yq1yz";
    url = "https://github.com/savonet/ocaml-mm/releases/download/0.3.1/ocaml-mm-0.3.1.tar.gz";
  };
}

