world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      bitv = opamSelection.bitv;
      camlzip = opamSelection.camlzip;
      conf-boost = opamSelection.conf-boost;
      conf-openbabel = opamSelection.conf-openbabel;
      conf-python-2-7 = opamSelection.conf-python-2-7;
      conf-rdkit = opamSelection.conf-rdkit;
      cpm = opamSelection.cpm;
      dolog = opamSelection.dolog;
      minivpt = opamSelection.minivpt;
      obuild = opamSelection.obuild;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      parmap = opamSelection.parmap;
      qcheck = opamSelection.qcheck;
      qtest = opamSelection.qtest;
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
  name = "lbvs_consent-1.1.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "lbvs_consent";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "184gypn6bp23pf7lrvwgx70mb2dns83nxdvpkx598w158zfxs4dx";
    url = "https://github.com/UnixJunkie/consent/archive/v1.1.2.tar.gz";
  };
}

