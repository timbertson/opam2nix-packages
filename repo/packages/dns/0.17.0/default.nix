world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      hashcons = opamSelection.hashcons;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-types = opamSelection.mirage-types or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      uri = opamSelection.uri;
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
  name = "dns-0.17.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dns";
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
    sha256 = "101scqakqdg2ks1pb40ljci6yzsvv4zq7bv2zdqp72cv2bgyidqi";
    url = "https://github.com/mirage/ocaml-dns/archive/v0.17.0.tar.gz";
  };
}

