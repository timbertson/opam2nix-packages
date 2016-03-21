world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."libsdl1.2-dev" or null) (pkgs.sdl or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-sdl-gfx = opamSelection.conf-sdl-gfx or null;
      conf-sdl-image = opamSelection.conf-sdl-image or null;
      conf-sdl-mixer = opamSelection.conf-sdl-mixer or null;
      conf-sdl-ttf = opamSelection.conf-sdl-ttf or null;
      lablgl = opamSelection.lablgl or null;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ocamlsdl-0.9.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocamlsdl";
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
    sha256 = "13sgkr87zzp4jdq7g5miqa6dyilblahqxn7xzybixh9x4rdjkyxb";
    url = "http://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz";
  };
}

