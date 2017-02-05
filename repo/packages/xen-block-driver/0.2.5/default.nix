world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      mirage-unix = opamSelection.mirage-unix;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      shared-memory-ring = opamSelection.shared-memory-ring;
      xenctrl = opamSelection.xenctrl;
      xenstore_transport = opamSelection.xenstore_transport;
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
  name = "xen-block-driver-0.2.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xen-block-driver";
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
    sha256 = "1xy5ciaprccqnnvpv6k8vi98g54b25v2n9y1djq79yp8v50d5kp9";
    url = "https://github.com/mirage/ocaml-xen-block-driver/archive/0.2.5.tar.gz";
  };
}

