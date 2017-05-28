world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      calendar = opamSelection.calendar;
      debian-formats = opamSelection.debian-formats;
      fileutils = opamSelection.fileutils;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocaml-inifiles = opamSelection.ocaml-inifiles;
      ocaml-xdg-basedir = opamSelection.ocaml-xdg-basedir;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pcre = opamSelection.pcre;
      xstrp4 = opamSelection.xstrp4;
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
  name = "oasis2debian-0.1.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "oasis2debian";
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
    sha256 = "0alabqcd5kc49p56qz3hq9h8gv2bq13c2hzx64gxrvkc53f4xxn6";
    url = "https://forge.ocamlcore.org/frs/download.php/1684/oasis2debian-0.1.3.tar.gz";
  };
}

