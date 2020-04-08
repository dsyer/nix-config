.PHONY: all

key = `cat ~/.ssh/id_rsa.pub`
email = dsyer@pivotal.io
name = "Dave Syer"

dotfiles = $(shell (cd templates; find dotfiles -type f))

all: nix/users.nix $(dotfiles)

nix/users.nix: ~/.ssh/id_rsa.pub
	cat templates/nix/users.nix | KEY=$(key) envsubst > nix/users.nix

dotfiles/%: templates/dotfiles/%
	cat $< | EMAIL=$(email) NAME=$(name) envsubst > $@
	LANG=C stow -v 2 -t ~ -S dotfiles

clean:
	rm -f nix/users.nix
	for f in $(shell (cd templates/dotfiles; find . -type f)); do rm -f dotfiles/$$f; done