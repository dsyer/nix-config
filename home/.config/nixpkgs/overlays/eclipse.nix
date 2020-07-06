self: super: {

  eclipse = with super.pkgs.eclipses; eclipseWithPlugins {
    eclipse = eclipse-platform;
    jvmArgs = [ "-Xmx2048m" ];
  };

}
