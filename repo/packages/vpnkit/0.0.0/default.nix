world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asl = opamSelection.asl;
      astring = opamSelection.astring;
      charrua-core = opamSelection.charrua-core;
      cmdliner = opamSelection.cmdliner;
      datakit-server = opamSelection.datakit-server;
      dns = opamSelection.dns;
      dns-forward = opamSelection.dns-forward;
      fd-send-recv = opamSelection.fd-send-recv;
      fmt = opamSelection.fmt;
      hashcons = opamSelection.hashcons;
      hvsock = opamSelection.hvsock;
      ipaddr = opamSelection.ipaddr;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      named-pipe = opamSelection.named-pipe;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pcap-format = opamSelection.pcap-format;
      result = opamSelection.result;
      tar-format = opamSelection.tar-format;
      tcpip = opamSelection.tcpip;
      uwt = opamSelection.uwt;
      win-eventlog = opamSelection.win-eventlog;
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
  name = "vpnkit-0.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vpnkit";
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
    sha256 = "0b101fla0iidiczif6y7rq78p5f5wi9fd4bqzd1d87qylq4c5fpd";
    url = "https://github.com/djs55/vpnkit/archive/v0.0.0.tar.gz";
  };
}

