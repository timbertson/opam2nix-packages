world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      conf-sdl-gfx = opamSelection.conf-sdl-gfx;
      conf-sdl-image = opamSelection.conf-sdl-image;
      conf-sdl-mixer = opamSelection.conf-sdl-mixer;
      conf-sdl-ttf = opamSelection.conf-sdl-ttf;
      jbuilder = opamSelection.jbuilder;
      lambda-term = opamSelection.lambda-term;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlsdl = opamSelection.ocamlsdl;
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
  name = "otetris-1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "otetris";
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
    sha256 = "0d781i3hxhg19pggzwgjb0gazqkrc13k4klh4dhkqyh11v02cjn6";
    url = "https://github.com/vzaliva/otetris/archive/v1.1.tar.gz";
  };
}

