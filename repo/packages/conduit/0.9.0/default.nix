world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      async_ssl = opamSelection.async_ssl or null;
      cstruct = opamSelection.cstruct;
      ipaddr = opamSelection.ipaddr;
      launchd = opamSelection.launchd or null;
      lwt = opamSelection.lwt or null;
      mirage-dns = opamSelection.mirage-dns or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sexplib = opamSelection.sexplib;
      ssl = opamSelection.ssl or null;
      stringext = opamSelection.stringext;
      tls = opamSelection.tls or null;
      uri = opamSelection.uri;
      vchan = opamSelection.vchan or null;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "conduit-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conduit";
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
    sha256 = "1dc77qhdhklqm8a1vpkha6cbwbmh037vin0ghwldnk51f89zhh6d";
    url = "https://github.com/mirage/ocaml-conduit/archive/v0.9.0.tar.gz";
  };
}

