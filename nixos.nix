{ pkgs, ... }:

let
  pkg = pkgs.callPackage ./. { };
in

{
  config = {
    systemd.services.occupado = {
      description = "Shut down the system when no-one's been logged in for an hour";
      script = "${pkg}/bin/occupado";
      serviceConfig.Type = "simple";
      onFailure = [ "halt.target" ];
    };

    systemd.timers.occupado = {
      description = "runs occupado service every hour, ten minutes before billing time";
      timerConfig = { OnBootSec = "50minutes"; OnUnitActiveSec = "1hour"; };
      wantedBy [ "timers.target" ];
    };
  };
}
