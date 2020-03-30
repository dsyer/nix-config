all: nix/users.nix
.PHONY: all

key=`cat ~/.ssh/id_rsa.pub`

nix/users.nix: ~/.ssh/id_rsa.pub
	cat templates/users.nix | KEY=$(key) envsubst > nix/users.nix

clean:
	rm nix/users.nix