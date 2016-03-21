world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      uri = opamSelection.uri;
      uuidm = opamSelection.uuidm;
      xapi-idl = opamSelection.xapi-idl;
      xapi-stdext = opamSelection.xapi-stdext;
      xenctrl = opamSelection.xenctrl;
      xenstore = opamSelection.xenstore;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "xapi-squeezed-0.10.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-squeezed";
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
    sha256 = "17fpnwlm5i4zjnpfg0gfj2frm74bck2q2rkykgl600by8bhcsk72";
    url = "https://github.com/xapi-project/squeezed/archive/0.10.7.tar.gz";
  };
}

