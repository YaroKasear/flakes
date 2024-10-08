{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.protomuck;
  service-name = replaceStrings [" " ":" "-"] ["" "" ""] (strings.toLower cfg.game-name);

in {
  options.united.protomuck = {
    enable = mkEnableOption "Protomuck";
    game-name = mkOpt types.str "ProtoMUCK" "Name of the MUCK server.";
    game-directory = mkOpt types.path "/var/lib/${service-name}" "Location of the MUCK files.";
    main-port = mkOpt types.port 8881 "Main port of the MUCK.";
    other-ports = mkOpt (types.listOf types.port) [] "Additiobal ports to listen on.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.united.protomuck
    ];

    users = {
      users.protomuck = {
        isSystemUser = true;
        group = "protomuck";
        uid = 2001;
      };
      groups.protomuck = {
        gid = 2001;
      };
    };

    fileSystems."/var/lib/${service-name}" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/protomuck/${service-name}";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    # Be advised you need to log onto the MUCK fully on its very first run or there will be segfaults on
    # subsequent starts. No idea why this is happening.
    systemd = {
      services."protomuck-${service-name}" = {
        enable = true;
        description = "ProtoMUCK server for ${cfg.game-name}.";
        after = [
          "network.target"
          "${substring 1 (stringLength cfg.game-directory - 1) (replaceStrings ["/"] ["-"] cfg.game-directory)}.mount"
        ];
        wantedBy = ["multi-user.target"];
        preStart = ''
          if [ -z "$(ls -A '${cfg.game-directory}')" ]; then
            echo "Creating MUCK files for ${cfg.game-name}."
            cp -r ${pkgs.united.protomuck}/game/{backup,data,logs,muf} ${cfg.game-directory}
            chmod -R u+w ${cfg.game-directory}
            cp ${pkgs.united.protomuck}/game/data/minimal.proto ${cfg.game-directory}/data/proto.db

          fi

          ls -l ${cfg.game-directory}
          chmod -R u+rw ${cfg.game-directory}
          chmod -R g+r ${cfg.game-directory}
          chmod -R g-w ${cfg.game-directory}
          chmod -R o-rw ${cfg.game-directory}
        '';
        path = [
          pkgs.gawk
          pkgs.gzip
          pkgs.procps
          pkgs.mailutils
        ];
        # serviceConfig.Type = "forking";
        serviceConfig = {
          Type = "exec";
          User = "protomuck";
          Group = "protomuck";
        };
        script = ''
          ulimit -c 50000
          ulimit -m 128000
          ulimit -s 16384

          cd ${cfg.game-directory}

          echo "Restarting at: `date`"

          umask 077

          muck=`ps x | grep protomuck | grep ": ${toString cfg.main-port}" | wc -l`
          datestamp=`date +%m%d%y%H%M`
          if [ "$muck" -gt 1 ]
          then
            echo "A protomuck is already running under this user:"
            echo  `ps x | grep protomuck | grep -v grep`
          fi

          # Save any corefile:
          timestamp="`date +'%y.%m.%d.%H.%M'`"
          if [ -r ${cfg.game-directory}/core ]
          then
              mv ${cfg.game-directory}/core ${cfg.game-directory}/core.$timestamp
          fi

          touch ${cfg.game-directory}/logs/restarts
          echo "`date` - `who am i`" >> logs/restarts

          if [ -r ${cfg.game-directory}/data/proto.new.PANIC ]
          then
            end=$(tail -1 ${cfg.game-directory}/data/proto.new.PANIC)
            if [ "$end" = "***END OF DUMP***" ]
            then
              mv ${cfg.game-directory}/data/proto.new.PANIC ${cfg.game-directory}/data/proto.new
              rm -f ${cfg.game-directory}/data/deltas-file
            else
              rm ${cfg.game-directory}/data/proto.new.PANIC
              echo "Warning: PANIC dump failed on $(date)" | mail "$(whoami)"
            fi
          fi

          rm -f ${cfg.game-directory}/data/proto.old ${cfg.game-directory}/data/proto.old.gz
          if [ -r ${cfg.game-directory}/data/proto.new ]
          then
            ( ${pkgs.united.protomuck}/bin/protomuck -convert -decompress ${cfg.game-directory}/data/proto.db ${cfg.game-directory}/data/proto.old ; gzip -8 ${cfg.game-directory}/data/proto.old ) &
            find ${cfg.game-directory}/data/proto.new -newer ${cfg.game-directory}/data/proto.db -exec mv -f ${cfg.game-directory}/data/proto.new ${cfg.game-directory}/data/proto.db \;
          fi

          if [ ! -r ${cfg.game-directory}/data/proto.db ]
          then
            echo "Hey\!  You gotta have a "${cfg.game-directory}/data/proto.db" file to restart the server\!"
            echo "Restart attempt aborted."
            exit 1
          fi

          end="`tail -1 ${cfg.game-directory}/data/proto.db`"
          if [ "$end" != '***END OF DUMP***' ]
          then
            echo "WARNING\!  The "${cfg.game-directory}/data/proto.db" file is incomplete and therefore corrupt\!"
            echo "Restart attempt aborted."
            exit 1
          fi

          if [ -r ${cfg.game-directory}/data/deltas-file ]
          then
            echo "Restoring from delta."
            end="`tail -1 ${cfg.game-directory}/data/deltas-file`"
            if [ "$end" == "***END OF DUMP***" ]
            then
              cat ${cfg.game-directory}/data/deltas-file >> ${cfg.game-directory}/data/proto.db
            else
              echo "Last delta is incomplete.  Truncating to previous dump."
              grep -n '^***END OF DUMP***' ${cfg.game-directory}/data/deltas-file|tail -1 >! .ftmp$$
              llinum="`cut -d: -f1 < .ftmp$$`"
              llcnt="`wc -l < .ftmp$$`"
              if [ $llcnt > 0 ]
              then
                head -$llinum ${cfg.game-directory}/data/deltas-file >> ${cfg.game-directory}/data/proto.db
              else
                echo "Hmm.  No previous delta dump."
              fi
              rm .ftmp$$
            fi
            rm -f ${cfg.game-directory}/data/deltas-file
          fi

          echo -n "(${cfg.game-name} on port ${toString cfg.main-port} from ${cfg.game-directory}/data/proto.db): "
          ${pkgs.united.protomuck}/bin/protomuck -verboseload -gamedir ${cfg.game-directory} -dbin ${cfg.game-directory}/data/proto.db -dbout ${cfg.game-directory}/data/proto.new -port "${toString cfg.main-port} ${strings.concatMapStrings (x: toString x + " ") cfg.other-ports}"

          tail -f ${cfg.game-directory}/logs/*
        '';
      };
      tmpfiles.settings."10-protomuck-${service-name}"."${cfg.game-directory}".d = {
        user = "protomuck";
        group = "protomuck";
        mode = "0700";
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.main-port] ++ cfg.other-ports;
  };
}