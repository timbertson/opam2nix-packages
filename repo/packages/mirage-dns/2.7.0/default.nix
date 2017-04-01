world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      dns = opamSelection.dns;
      duration = opamSelection.duration;
      io-page = opamSelection.io-page;
      lwt = opamSelection.lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      ocaml = opamSelection.ocaml;
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
  name = "mirage-dns-2.7.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-dns";
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
    sha256 = "09lf02kz6bhlpxxcgvxlyd4sdninsyxfsbi7id5r9ps2y9p3zy17";
    url = "https://github.com/mirage/ocaml-dns/archive/v0.20.0.tar.gz";
  };
}

