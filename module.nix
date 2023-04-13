{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.hasplmd;
in
{

  options.services.hasplmd = {
    enable = mkEnableOption (mdDoc "Sentinel Keys Admin Control Center");
  };

  config = mkIf cfg.enable {
    systemd.services.hasplmd = {
      description = "Sentinel LDK Runtime Environment (hasplmd daemon)";

      requires = [ "aksusbd.service" ];
      after = [ "aksusbd.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.aksusbd}/bin/hasplmd -s";
        Type = "forking";
      };
    };

    systemd.services.aksusbd = {
      description = "Sentinel LDK Runtime Environment (aksusbd daemon)";

      requires = [ "hasplmd.service" ];
      before = [ "hasplmd.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.aksusbd}/bin/aksusbd";
        Type = "forking";
      };
    };
    system.activationScripts.haspVendorLib = lib.stringAfter [ "var" ] ''
      mkdir -p /var/hasplm
      for lib in ${pkgs.aksusbd}/haspvlib/*.so; do
        bn="$(basename $lib)"
        ln -sf "$lib" /var/hasplm/$bn
      done
    '';
  };
}
