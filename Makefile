.PHONY: all

key = `cat ~/.ssh/id_rsa.pub`
user = ${USER}
email = dsyer@pivotal.io
name = "Dave Syer"
host = $(shell hostname)

home = $(shell (cd templates; find home -type f))

all: nix/packages/users.nix home

nix/packages/users.nix: ~/.ssh/id_rsa.pub
	cat templates/nix/packages/users.nix | KEY=$(key) envsubst > nix/packages/users.nix

clean:
	rm -f nix/packages/users.nix
	rm -f home/.gitconfig

home: $(home)

home/%: templates/home/%
	cat $< | EMAIL=$(email) NAME=$(name) envsubst > $@
	find home -type f -exec sed -i -e 's/dsyer/$(user)/g' {} \;

install:
	mkdir -p ~/bin
	mkdir -p ~/.config/Code/User
	mkdir -p ~/.local/share/applications
	LANG=C stow -v 2 -t ~ -S home
	if [ -d "hosts/$(host)" ]; then cd hosts; LANG=C stow -v 2 -t ~ -S $(host); else cd hosts; LANG=C stow -v 2 -t ~ -S default; fi

clean-home:
	rm -rf ~/.config/nixpkgs
	for f in $(shell (cd templates/home; find . -type f)); do rm -f ~/$$f; done
	for f in $(shell (cd templates/home; find . -type f)); do rm -f home/$$f; done
