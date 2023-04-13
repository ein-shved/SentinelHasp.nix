{ lib, pkgs, stdenv, aksusbd_vlib, system,
  autoPatchelfHook
}:
let
  arch = (lib.systems.elaborate system).parsed.cpu.name;
in
stdenv.mkDerivation {
  name = "aksusbd";
  src = aksusbd_vlib;
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  installPhase = ''
    haspvlib="haspvlib_${arch}_46707.so"
    [ -f "$haspvlib" ] && install $haspvlib -D $out/haspvlib/$haspvlib
    install -D bin/aksusbd_${arch} $out/bin/aksusbd
    install -D bin/hasplmd_${arch} $out/bin/hasplmd
    install -D bin/install_v2c_${arch} $out/bin/install_v2c
  '';
}
