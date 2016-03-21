world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      channel = opamSelection.channel;
      cstruct = opamSelection.cstruct;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-console = opamSelection.mirage-console;
      mirage-net-unix = opamSelection.mirage-net-unix;
      mirage-profile = opamSelection.mirage-profile;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      mirage-unix = opamSelection.mirage-unix;
      mirage-xen = opamSelection.mirage-xen or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "tcpip-2.5.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tcpip";
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
    sha256 = "0d60si2v82qpcx8k0gvksddsgnrsl7zsfcira079n6z3jv8y3g1r";
    url = "https://github.com/mirage/mirage-tcpip/archive/v2.5.1.tar.gz";
  };
}

