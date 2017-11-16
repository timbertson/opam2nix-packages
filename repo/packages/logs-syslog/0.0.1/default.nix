world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct or null;
      io-page = opamSelection.io-page or null;
      ipaddr = opamSelection.ipaddr or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt or null;
      mirage-types = opamSelection.mirage-types or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ptime = opamSelection.ptime;
      result = opamSelection.result;
      syslog-message = opamSelection.syslog-message;
      tls = opamSelection.tls or null;
      topkg = opamSelection.topkg;
      x509 = opamSelection.x509 or null;
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
  name = "logs-syslog-0.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "logs-syslog";
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
    sha256 = "1ymg1cmyqjcgrdan9bzlzayal9y74ih10fyr8dif9r1h5dl41886";
    url = "https://github.com/hannesm/logs-syslog/releases/download/0.0.1/logs-syslog-0.0.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

