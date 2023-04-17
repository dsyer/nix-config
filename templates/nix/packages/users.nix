{ config, pkgs, ... }: {

  users.groups.builder = {
    name = "${USER}";
    members = [ "${USER}" ];
    gid = 1000;
  };

  users.extraUsers.builder = {
    isNormalUser = true;
    uid = 1000;
    group = "${USER}";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" "audio" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "${KEY}" ];
  };

}
