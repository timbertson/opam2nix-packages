world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.gnupg2 or null) (pkgs.unzip or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
      extlib = opamSelection.extlib;
      lablgtk = opamSelection.lablgtk or null;
      lwt = opamSelection.lwt;
      lwt_glib = opamSelection.lwt_glib or null;
      lwt_react = opamSelection.lwt_react;
      obus = opamSelection.obus or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ocurl = opamSelection.ocurl;
      sha = opamSelection.sha;
      xmlm = opamSelection.xmlm;
      yojson = opamSelection.yojson;
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
  name = "0install-2.12.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "0install";
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
    sha256 = "109nr4lq40pw712pm901r28bryssw9w1h347qbkrv9zjd88pddc7";
    url = "https://downloads.sf.net/project/zero-install/0install/2.12.1/0install-2.12.1.tar.bz2";
  };
}

