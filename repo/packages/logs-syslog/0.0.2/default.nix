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
  name = "logs-syslog-0.0.2";
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
    sha256 = "0p568vlka6fjm5n1nzz1vs6mmn90mnl22jmq31l8yvbas5s4avkv";
    url = "https://github.com/hannesm/logs-syslog/releases/download/0.0.2/logs-syslog-0.0.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

