world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.gst-plugins-base or null) (pkgs.gst-plugins-base1-dev or null)
        (pkgs.gstreamer or null) (pkgs.gstreamer-devel or null)
        (pkgs.gstreamer-plugins-base-devel or null)
        (pkgs.gstreamer1-dev or null) (pkgs.gstreamer1-devel or null)
        (pkgs.gstreamer1-plugins-base-devel or null)
        (pkgs."libgstreamer-plugins-base1.0-dev" or null)
        (pkgs."libgstreamer1.0-dev" or null) ] ++ (lib.attrValues opamDeps));
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
  name = "gstreamer-0.2.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "gstreamer";
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
    sha256 = "1z86izghzfqd39m0j64pz13sjm5szap2gjfhcplma2w7pbb1xncy";
    url = "https://github.com/savonet/ocaml-gstreamer/releases/download/0.2.3/ocaml-gstreamer-0.2.3.tar.gz";
  };
}

