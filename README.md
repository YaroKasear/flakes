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
