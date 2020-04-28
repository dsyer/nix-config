{ config, pkgs, ... }: {

  users.groups.dsyer = {
    name = "${USER}";
    members = [ "${USER}" ];
    gid = 1000;
  };

  users.extraUsers.dsyer = {
    isNormalUser = true;
    uid = 1000;
    group = "${USER}";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "${KEY}" ];
  };

}
