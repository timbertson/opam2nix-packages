world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlzip = opamSelection.camlzip;
      conf-autoconf = opamSelection.conf-autoconf;
      conf-gtksourceview = opamSelection.conf-gtksourceview or null;
      lablgtk = opamSelection.lablgtk or null;
      menhir = opamSelection.menhir;
      num = opamSelection.num;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-simplex = opamSelection.ocplib-simplex;
      zarith = opamSelection.zarith;
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
  name = "alt-ergo-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "alt-ergo";
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
    sha256 = "1p34vsij83g9fpjh9dnxjcvkzps16gwbdvl2990c3sljniylrrjz";
    url = "http://alt-ergo.ocamlpro.com/http/alt-ergo-2.0.0/alt-ergo-2.0.0.tar.gz";
  };
}

