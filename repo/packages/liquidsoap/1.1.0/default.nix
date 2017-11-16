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
      aacplus = opamSelection.aacplus or null;
      alsa = opamSelection.alsa or null;
      ao = opamSelection.ao or null;
      bjack = opamSelection.bjack or null;
      camomile = opamSelection.camomile;
      cry = opamSelection.cry or null;
      dssi = opamSelection.dssi or null;
      dtools = opamSelection.dtools;
      duppy = opamSelection.duppy;
      faad = opamSelection.faad or null;
      ffmpeg = opamSelection.ffmpeg or null;
      flac = opamSelection.flac or null;
      frei0r = opamSelection.frei0r or null;
      gavl = opamSelection.gavl or null;
      inotify = opamSelection.inotify or null;
      ladspa = opamSelection.ladspa or null;
      lame = opamSelection.lame or null;
      lastfm = opamSelection.lastfm or null;
      lo = opamSelection.lo or null;
      mad = opamSelection.mad;
      mm = opamSelection.mm;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ogg = opamSelection.ogg or null;
      opus = opamSelection.opus or null;
      pcre = opamSelection.pcre;
      portaudio = opamSelection.portaudio or null;
      pulseaudio = opamSelection.pulseaudio or null;
      samplerate = opamSelection.samplerate or null;
      schroedinger = opamSelection.schroedinger or null;
      soundtouch = opamSelection.soundtouch or null;
      speex = opamSelection.speex or null;
      taglib = opamSelection.taglib or null;
      theora = opamSelection.theora or null;
      voaacenc = opamSelection.voaacenc or null;
      vorbis = opamSelection.vorbis or null;
      xmlplaylist = opamSelection.xmlplaylist or null;
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
  name = "liquidsoap-1.1.0";
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
    sha256 = "1fk8phv98nsg2cfngxqm6fqhr3x1psjmm8q00dhg1kj2bi3yj351";
    url = "http://downloads.sourceforge.net/project/savonet/liquidsoap/1.1.0/liquidsoap-1.1.0.tar.bz2";
  };
}

