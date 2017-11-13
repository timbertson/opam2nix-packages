world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      camomile = opamSelection.camomile;
      cppo = opamSelection.cppo;
      jbuilder = opamSelection.jbuilder;
      lambda-term = opamSelection.lambda-term;
      lwt = opamSelection.lwt;
      lwt_react = opamSelection.lwt_react;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      react = opamSelection.react;
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
  name = "utop-2.0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "utop";
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
    sha256 = "1q5sv48jq9hjwlj08dkaalkqcjxml1hsm14rb1i0x7k9769jsfrn";
    url = "https://github.com/diml/utop/releases/download/2.0.2/utop-2.0.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

