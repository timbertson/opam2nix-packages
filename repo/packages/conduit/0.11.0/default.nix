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
      pa_sexp_conv = opamSelection.pa_sexp_conv;
      ssl = opamSelection.ssl or null;
      stringext = opamSelection.stringext;
      tls = opamSelection.tls or null;
      type_conv = opamSelection.type_conv;
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
  name = "conduit-0.11.0";
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
    sha256 = "13pgf00c4r60pgrnlp3dr4d2ljxyh74c059ym37jp4wvfg0i3vpn";
    url = "https://github.com/mirage/ocaml-conduit/archive/v0.11.0.tar.gz";
  };
}

