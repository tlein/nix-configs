# Installation

## Install Nix (Linux and macOS) via one of the following installers

### 1.) [Official Installer](https://nixos.org/manual/nix/stable/installation/installing-binary.html)

The following will install single-user on Linux and multi-user on macOS:

```shell
sh <(curl -L https://nixos.org/nix/install)
```

To install multi-user on Linux:

```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Enable Flakes by creating a file in `~/.config/nix/nix.conf` and adding the following:

```shell
experimental-features = nix-command flakes
```

### 2.) [Determinate Systems Installer](https://zero-to-nix.com/concepts/nix-installer)

The following will install Nix on either Linux or macOS:

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Flakes should already be enabled after install with this method

## Clone Repo
```shell
nix-shell -P git # If you need access to git
git clone git@github.com:tlein/nix-configs.git ~/.nix-configs
```

## Build Flake

Substitute `macos-personal-laptop` for current machine's configuration

### On Darwin:
```shell
cd ~/.nix-configs
nix build ".#darwinConfigurations.macos-personal-laptop.system"
./result/sw/bin/darwin-rebuild switch --flake ".#macos-personal-laptop"
```

### On NixOS:
```shell
cd ~/.nix-configs
nix build ".#nixosConfigurations.macos-personal-laptop.system"
sudo ./result/sw/bin/nixos-rebuild switch --flake ".#mac-ospersonal-laptop"
```

# Updating

## Updating flake.lock

If the flake.lock needs to be updated:

```shell
nix flake update
```

## Rebuilding and Switching

To rebuild after making changes:

### On Darwin

```shell
darwin-rebuild build --flake ".#macos-personal-laptop"
darwin-rebuild switch --flake ".#macos-personal-laptop"
```

### On NixOS:
```shell
sudo nixos-rebuild build --flake ".#macos-personal-laptop"
sudo nixos-rebuild switch --flake ".#macos-personal-laptop"
```

# Creating new configurations

1. Create a new folder in the `hosts` folder with the name of the configuration.
2. Inside that folder, create a `configuration.nix` with a NixOS or Darwin config, and a `home.nix` with a home manager config.
3. Add a new configuration to either the `nixosConfigurations` or `darwinConfigurations` block of the `flake.nix`, specifying the system type, host (the name of the folder from step 1), and user (to install the home manager config to).

# Devshell

This flake uses the [devshell](https://github.com/numtide/devshell) project to easily setup a dev environment when in this project's directory.  It adds a few packages to the environment, as well as aliases to format, lint, and build various images.

To enter the devshell without `direnv`, run

```shell
nix develop
```

If you use `direnv`, it should become available anytime you are in the directory after running

```shell
direnv allow
```
