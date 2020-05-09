.PHONY: all

key = `cat ~/.ssh/id_rsa.pub`
email = dsyer@pivotal.io
name = "Dave Syer"

home = $(shell (cd templates; find home -type f))

all: nix/packages/users.nix home

nix/packages/users.nix: ~/.ssh/id_rsa.pub
	cat templates/nix/packages/users.nix | KEY=$(key) envsubst > nix/packages/users.nix

clean:
	rm -f nix/users.nix

home: $(home)

home/%: templates/home/%
	cat $< | EMAIL=$(email) NAME=$(name) envsubst > $@

install:
	mkdir -p ~/.config/Code/User
	mkdir -p ~/.local/share
	LANG=C stow -v 2 -t ~ -S home

clean-home:
	for f in $(shell (cd templates/home; find . -type f)); do rm -f ~/$$f; done
	for f in $(shell (cd templates/home; find . -type f)); do rm -f home/$$f; done
