pkgs: with pkgs; 
if (builtins.pathExists "/sys/hypervisor/uuid") then
    # EC2 (could also check that the file contains an ID starting with "ec2")
    [ jdk11 ]
  else
    [ ]