world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      archive = opamSelection.archive or null;
      base-threads = opamSelection.base-threads or null;
      camlbz2 = opamSelection.camlbz2 or null;
      extlib = opamSelection.extlib or null;
      extlib-compat = opamSelection.extlib-compat or null;
      fileutils = opamSelection.fileutils or null;
      lwt = opamSelection.lwt or null;
      lwt-android = opamSelection.lwt-android or null;
      oasis = opamSelection.oasis or null;
      oasis-mirage = opamSelection.oasis-mirage or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocurl = opamSelection.ocurl or null;
      ounit = opamSelection.ounit;
      pcre = opamSelection.pcre or null;
      re = opamSelection.re;
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
  name = "debian-formats-0.1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "debian-formats";
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
    sha256 = "0wgr68748ayxnvjfl01zfkpqjjnhjfvhlsb0gp1hv6kgixl87mqc";
    url = "https://forge.ocamlcore.org/frs/download.php/1682/ocaml-debian-formats-0.1.1.tar.gz";
  };
}

