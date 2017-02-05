world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libxen-dev or null) (pkgs.uuid-dev or null)
        (pkgs.xen-devel or null) (pkgs.xen-dom0-libs-devel or null)
        (pkgs.xen-libs-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
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
  name = "xenctrl-0.9.32";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xenctrl";
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
    sha256 = "15kf9fsyjc6h44m83cgi5ksq7lqc42312fq0nyn13gv3qwn63kak";
    url = "https://github.com/xapi-project/ocaml-xen-lowlevel-libs/archive/v0.9.32.tar.gz";
  };
}

