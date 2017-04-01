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
      ipaddr = opamSelection.ipaddr or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt or null;
      mirage-clock = opamSelection.mirage-clock or null;
      mirage-console-lwt = opamSelection.mirage-console-lwt or null;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt or null;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ptime = opamSelection.ptime;
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
  name = "logs-syslog-0.1.0";
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
    sha256 = "1xx1i5mg0pd99alzzbd01dd17ikdgsm2rgf100rijv6rg1cdal5s";
    url = "https://github.com/hannesm/logs-syslog/releases/download/0.1.0/logs-syslog-0.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

