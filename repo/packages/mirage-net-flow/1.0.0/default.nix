world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct-lwt = opamSelection.cstruct-lwt;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
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
  name = "mirage-net-flow-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-net-flow";
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
    sha256 = "175d53i13dfj4a044yhsgvg80dm7sdil6zph7j8rkvi5nczhp6jv";
    url = "https://github.com/mirage/mirage-net-flow/releases/download/1.0.0/mirage-net-flow-1.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

