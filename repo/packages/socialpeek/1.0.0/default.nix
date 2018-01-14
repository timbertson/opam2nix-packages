world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      jbuilder = opamSelection.jbuilder;
      lambdasoup = opamSelection.lambdasoup;
      lwt_ssl = opamSelection.lwt_ssl;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ounit = opamSelection.ounit or null;
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
  name = "socialpeek-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "socialpeek";
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
    sha256 = "1br4xfwyp8kkaknc54pw6n24kzaxf0dni4si52vgxvmnx0wlc4fv";
    url = "https://github.com/erizocosmico/ocaml-socialpeek/archive/1.0.0.tar.gz";
  };
}

