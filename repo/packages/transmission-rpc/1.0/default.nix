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
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      rresult = opamSelection.rresult;
      yojson = opamSelection.yojson;
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
  name = "transmission-rpc-1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "transmission-rpc";
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
    sha256 = "0plplkwqr7x1l9pfkrxzwsa70bibi1xv8x1q5crj1m68i9bfwvx8";
    url = "https://github.com/bataille/ocaml-transmission-rpc/archive/1.0.tar.gz";
  };
}

