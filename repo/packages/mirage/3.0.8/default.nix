world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      bos = opamSelection.bos;
      functoria = opamSelection.functoria;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      mirage-runtime = opamSelection.mirage-runtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "mirage-3.0.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage";
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
    sha256 = "10sqwjbfk110vvxxvr5mhsd849r32baihzwcc2r3c0s5ndnz6cyk";
    url = "https://github.com/mirage/mirage/releases/download/v3.0.8/mirage-3.0.8.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

