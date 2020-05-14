self: super: {
    hello = super.hello.overrideAttrs(oldAttrs: rec {
        version = "2.9";
        src = self.fetchurl {
            url = "mirror://gnu/hello/${super.hello.pname}-${version}.tar.gz";
            sha256 = "19qy37gkasc4csb1d3bdiz9snn8mir2p3aj0jgzmfv0r2hi7mfzc";        
        };
    });
 }
