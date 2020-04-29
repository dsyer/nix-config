{ config, pkgs, ... }: {

  users.groups.user = {
    name = "${USER}";
    members = [ "${USER}" ];
    gid = 1000;
  };

  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    group = "${USER}";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "${KEY}" ];
  };

}
