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
      dns-forward = opamSelection.dns-forward;
      io-page-unix = opamSelection.io-page-unix;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
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
  name = "dns-forward-lwt-unix-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dns-forward-lwt-unix";
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
    sha256 = "12sj6vl44mgklbm770l0v59h8kprw0j530brg9czlg9gwkdcs4xz";
    url = "https://github.com/mirage/ocaml-dns-forward/releases/download/v0.9.0/dns-forward-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

