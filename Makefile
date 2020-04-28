.PHONY: all

key = `cat ~/.ssh/id_rsa.pub`
email = dsyer@pivotal.io
name = "Dave Syer"

home = $(shell (cd templates; find home -type f))

all: nix/users.nix $(home)

nix/users.nix: ~/.ssh/id_rsa.pub
	cat templates/nix/users.nix | KEY=$(key) envsubst > nix/users.nix

home/%: templates/home/%
	cat $< | EMAIL=$(email) NAME=$(name) envsubst > $@
	LANG=C stow -v 2 -t ~ -S home

clean:
	rm -f nix/users.nix
	for f in $(shell (cd templates/home; find . -type f)); do rm -f ~/$$f; done
	for f in $(shell (cd templates/home; find . -type f)); do rm -f home/$$f; done
