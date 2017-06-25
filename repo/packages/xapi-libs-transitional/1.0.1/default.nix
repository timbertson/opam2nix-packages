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
      ezxenstore = opamSelection.ezxenstore;
      ocaml = opamSelection.ocaml;
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
  name = "xapi-libs-transitional-1.0.1";
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
    sha256 = "1zccy8b91cl3wg46rppa1k73lqqsx48alnrfs6f26h4za92zrks0";
    url = "https://github.com/xapi-project/xen-api-libs-transitional/archive/v1.0.1.tar.gz";
  };
}

