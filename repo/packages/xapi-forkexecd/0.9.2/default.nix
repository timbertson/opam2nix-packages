world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      fd-send-recv = opamSelection.fd-send-recv;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      syslog = opamSelection.syslog;
      uuidm = opamSelection.uuidm;
      xapi-idl = opamSelection.xapi-idl;
      xapi-stdext = opamSelection.xapi-stdext;
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
  name = "xapi-forkexecd-0.9.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-forkexecd";
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
    sha256 = "0f287brfs7g26myd6dvdb0pjyixfkkgs5wv83ljaxw41402pk1l0";
    url = "https://github.com/xapi-project/forkexecd/archive/0.9.2/forkexecd-0.9.2.tar.gz";
  };
}

