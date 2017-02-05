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
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      ppx_tools = opamSelection.ppx_tools;
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
  name = "ppx_json_types-0.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_json_types";
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
    sha256 = "0x3cgxc8qy76dp5jyw8mfhw1q4r8l1719w52f07i78s0d1qmv8i8";
    url = "https://github.com/nv-vn/otp/archive/0.3.tar.gz";
  };
}

