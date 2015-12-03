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
      lwt = opamSelection.lwt or null;
      mirage-dns = opamSelection.mirage-dns or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      ocaml = opamSelection.ocaml;
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
  name = "conduit-0.8.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conduit";
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0zbw5dqlax5dvzy6m5r78s7gck6df23gbiwinx0kxkb9b7jaw7sc";
    url = "https://github.com/mirage/ocaml-conduit/archive/v0.8.7.tar.gz";
  };
}

