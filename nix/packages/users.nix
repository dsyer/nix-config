{ config, pkgs, ... }: {

  users.groups.builder = {
    name = "dsyer";
    members = [ "dsyer" ];
    gid = 1000;
  };

  users.extraUsers.builder = {
    isNormalUser = true;
    uid = 1000;
    group = "dsyer";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" "audio" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA4yvDJ+mZfpMbCaPuZJ4jVmFHbTiN3ksCOvWj/4n9occuM0hMSqGlIvQ3686XB2ZUmxnN7Z4LGNS4eFYTdRZ6XXoEfdXXJBKMKLZwr5YBJasIV7bBiTFjX6lJDOkzRK0G5qyjO29z2nW3JfoReBXLzOOITuLj0bjWZTUsdrQ4tmOlPUtVe30yql/06YWcdn0jII1PASDw2yrRvbeOFM/nig3zElzb6+m8V5Y9BQ5HyDd6sdMTCwWiYWC1/S6EOmvB3HadbeNdH4LjoEgXGBJ/6u5icavpWQOmFQ5M/ZLkkfokkCIQQEIUHdFVGx5y4myvVPWEGQ79aOpVrBr1WxaJDw== dsyer_rsa" ];
  };

}
