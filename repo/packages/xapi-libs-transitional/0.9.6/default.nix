world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libxen-dev or null) (pkgs.xen-devel or null)
        (pkgs.xen-dom0-libs-devel or null) (pkgs.xen-libs-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      rpc = opamSelection.rpc;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-stdext = opamSelection.xapi-stdext;
      xenctrl = opamSelection.xenctrl;
      xenstore = opamSelection.xenstore;
      xenstore_transport = opamSelection.xenstore_transport;
      xmlm = opamSelection.xmlm;
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
  name = "xapi-libs-transitional-0.9.6";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-libs-transitional";
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
    sha256 = "0jvnn85r6iblavy8rfdrwlv4svazgc058mdxx7xqkzizykvq7sny";
    url = "https://github.com/xapi-project/xen-api-libs-transitional/archive/v0.9.6.tar.gz";
  };
}

