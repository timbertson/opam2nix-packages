world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libao-dev or null) (pkgs.libfaad-dev or null)
        (pkgs.libflac-dev or null) (pkgs.libgavl-dev or null)
        (pkgs."libgstreamer-plugins-base0.10-dev" or null)
        (pkgs."libgstreamer0.10-dev" or null)
        (pkgs."libgstreamer1.0-dev" or null) (pkgs.liblo-dev or null)
        (pkgs.libmp3lame-dev or null) (pkgs.libogg-dev or null)
        (pkgs.libsamplerate-dev or null) (pkgs.libschroedinger-dev or null)
        (pkgs.libsoundtouch-dev or null) (pkgs.libspeex-dev or null)
        (pkgs.libtheora-dev or null) (pkgs.libvo-aacenc-dev or null)
        (pkgs.libvorbis-dev or null) (pkgs.portaudio19-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlidl = opamSelection.camlidl;
      camomile = opamSelection.camomile;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      pcre = opamSelection.pcre;
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
  name = "liquidsoap-1.0.1-full";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "liquidsoap";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "04n0d5kpscn3qkr09sf02ycls53ws8sha542z1yi5dsifgb9czny";
    url = "http://downloads.sourceforge.net/project/savonet/liquidsoap/1.0.1/liquidsoap-1.0.1-full.tar.bz2";
  };
}

