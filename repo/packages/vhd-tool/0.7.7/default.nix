world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      nbd = opamSelection.nbd;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      sha = opamSelection.sha;
      ssl = opamSelection.ssl;
      tar-format = opamSelection.tar-format;
      uri = opamSelection.uri;
      uuidm = opamSelection.uuidm;
      vhd-format = opamSelection.vhd-format;
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
  name = "vhd-tool-0.7.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vhd-tool";
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
    sha256 = "1281wvd083p0k4fr1mp25f3wxl43js5f3a5jvy8ig0r425y7wwln";
    url = "https://github.com/djs55/vhd-tool/archive/v0.7.7.tar.gz";
  };
}

