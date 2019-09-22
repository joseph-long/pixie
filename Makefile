.PHONY: all

all:
	sudo rsync -av ./nixos/ /etc/nixos/
	sudo nixos-rebuild switch