world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
      mirage-solo5 = opamSelection.mirage-solo5;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "mirage-net-solo5-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-net-solo5";
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
    sha256 = "1sqsfaz5jx13pf5k9lhxlq0yjwjnf2il5z5f6d4cb6gbp57r6ya4";
    url = "https://github.com/mirage/mirage-net-solo5/releases/download/v0.2.0/mirage-net-solo5-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

