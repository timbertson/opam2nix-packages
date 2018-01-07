world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      asl = opamSelection.asl;
      astring = opamSelection.astring;
      charrua-client-mirage = opamSelection.charrua-client-mirage or null;
      charrua-core = opamSelection.charrua-core;
      cmdliner = opamSelection.cmdliner;
      cohttp-lwt = opamSelection.cohttp-lwt;
      cstruct-lwt = opamSelection.cstruct-lwt;
      datakit-server = opamSelection.datakit-server;
      datakit-server-9p = opamSelection.datakit-server-9p;
      dns = opamSelection.dns;
      dns-forward = opamSelection.dns-forward;
      dns-lwt = opamSelection.dns-lwt;
      dnssd = opamSelection.dnssd;
      ezjsonm = opamSelection.ezjsonm;
      fd-send-recv = opamSelection.fd-send-recv;
      fmt = opamSelection.fmt;
      hashcons = opamSelection.hashcons;
      hvsock = opamSelection.hvsock;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-channel = opamSelection.mirage-channel;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-dns = opamSelection.mirage-dns;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-protocols = opamSelection.mirage-protocols;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      mirage-vnetif = opamSelection.mirage-vnetif;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      pcap-format = opamSelection.pcap-format;
      protocol-9p = opamSelection.protocol-9p;
      result = opamSelection.result;
      stringext = opamSelection.stringext;
      tar = opamSelection.tar;
      tcpip = opamSelection.tcpip;
      uuidm = opamSelection.uuidm;
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
  name = "vpnkit-0.2.0";
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
    sha256 = "19nac93i51rpw97yzvxvd9427wv23nd1q9d17h65ln1mibpmkrqs";
    url = "https://github.com/moby/vpnkit/releases/download/v0.2.0/vpnkit-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

