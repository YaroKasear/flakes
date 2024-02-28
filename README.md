# Multi User Test Config

This branch of my flake is being used to demonstrate an issue I have not been able to clear up regarding adding an additional user's home into the configuration.

Specifically for this branch, the new home "cnelson@loki" has all modules removed and `united.common.enable = false` set.

The following error occurs.

```
error:
       … while calling the 'head' builtin

         at /nix/store/yjx2075p6xz76l6ldx1lzm1qk22li2ps-source/lib/attrsets.nix:960:11:

          959|         || pred here (elemAt values 1) (head values) then
          960|           head values
             |           ^
          961|         else

       … while evaluating the attribute 'value'

         at /nix/store/yjx2075p6xz76l6ldx1lzm1qk22li2ps-source/lib/modules.nix:809:9:

          808|     in warnDeprecation opt //
          809|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          810|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: The option `home-manager.users.cnelson.united.common.enable' has conflicting definition values:
       - In `/nix/store/a4gsrpgj9w9mj3r7wk3q44w29b1xfh1q-qx0f16r75q0b7sf0wfn04q3367g6gb1s-source/homes/x86_64-linux/cnelson@loki/default.nix': false
       - In `/nix/store/a4gsrpgj9w9mj3r7wk3q44w29b1xfh1q-qx0f16r75q0b7sf0wfn04q3367g6gb1s-source/homes/x86_64-linux/yaro@loki/default.nix': true
       Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
~
```

The expected behavior here was that yaro@home would build its own configuration with the common module enabled and the cnelson@home would build its own configuration without. Instead there's a conflict.

Further, though it's not reflected in this branch: If I were to have config enabled, yaro's configuration will be overwritten by cnelson's, with a lot of files referencing /home/cnelson in dotfiles placed in /home/yaro. 

It results in weird behavior like the below:

```
activating the configuration...
setting up /etc...
reloading user units for yaro...
restarting sysinit-reactivation.target
restarting the following units: home-manager-yaro.service
Job for home-manager-yaro.service failed because the control process exited with error code.
See "systemctl status home-manager-yaro.service" and "journalctl -xeu home-manager-yaro.service" for details.
the following new units were started: home-manager-cnelson.service
warning: the following units failed: home-manager-yaro.service

× home-manager-yaro.service - Home Manager environment for yaro
     Loaded: loaded (/etc/systemd/system/home-manager-yaro.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Wed 2024-02-28 08:55:06 CST; 82ms ago
   Duration: 15min 57.474s
    Process: 19263 ExecStart=/nix/store/0l615v39ak6wbnsi1zlmv88xz5grwvn9-hm-setup-env /nix/store/cfz3l6vls1h62b6hhdivmr29kmq5b6ds-home-manager-generation (code=exited, status=1/FAILURE)
   Main PID: 19263 (code=exited, status=1/FAILURE)
         IP: 0B in, 0B out
        CPU: 3.325s

Feb 28 08:55:03 loki hm-activate-yaro[19263]: Creating home file links in /home/yaro
Feb 28 08:55:06 loki hm-activate-yaro[19263]: Activating batCache
Feb 28 08:55:06 loki hm-activate-yaro[22826]: No themes were found in '/home/yaro/.config/bat/themes', using the default set
Feb 28 08:55:06 loki hm-activate-yaro[22826]: No syntaxes were found in '/home/yaro/.config/bat/syntaxes', using the default set.
Feb 28 08:55:06 loki hm-activate-yaro[22826]: [bat error]: Could not save theme set to /home/cnelson/.cache/bat/themes.bin
Feb 28 08:55:06 loki hm-activate-yaro[22826]: Writing theme set to /home/cnelson/.cache/bat/themes.bin ...
Feb 28 08:55:06 loki systemd[1]: home-manager-yaro.service: Main process exited, code=exited, status=1/FAILURE
Feb 28 08:55:06 loki systemd[1]: home-manager-yaro.service: Failed with result 'exit-code'.
Feb 28 08:55:06 loki systemd[1]: Failed to start Home Manager environment for yaro.
Feb 28 08:55:06 loki systemd[1]: home-manager-yaro.service: Consumed 3.325s CPU time, no IP traffic.
warning: error(s) occurred while switching to the new configuration
```

As a note, in modules/home/user/default.nix I did fix up the cfg.directories.home to `"${home-directory}/${cfg.name}"` and changed the home-directory assignment to only assign either "/home" or "/User" which resulted in the above. Again, the expected behavior is for cnelson's dotfiles to be written independently of yaro's in ~cnelson, not alter ~yaro in any way. 

I'm not sure if this is a bug or if I'm using snowfall-lib improperly. Some clarification on how to set up multiple homes sharing modules and configuring them/enabling them differently would be appreciated. 
