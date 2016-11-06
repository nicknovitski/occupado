# occupado
> Tell if anyone's logged in to the system currently or recently.

## Table of Contents

- [Background](#background)
- [NixOS](#nixos)
- [Installation](#installation)
- [Usage](#usage)
- [Contribute](#contribute)

## Background

I do most of my writing and development on public cloud instances, and I hate
having to remember to turn them off when I'm done with them.

Solving that problem required an executable which has a failing exit status
when the system seems to not be "in use" any more.  This repository hosts that script.

It's written in Python, because the person who helped me determine I shouldn't
write it in Bash was [David Strauss](https://github.com/davidstrauss), and he
knew the python systemd bindings would help.

## NixOS

This repository is written as a NixOS module, so on NixOS systems, all you
have to do is clone it somewhere on your system, and add it to your imports:
```nix
# /etc/nixos/configuration.nix
{ pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
    /a/path/to/occupado/nixos.nix
    ];

  # Your system's configuration
}
```

And with that, your VM (an AWS instance, apparently) will shut down ten minutes
before you're billed for another hour, as long as you haven't connected to it
in the past hour.

## Installation

If you aren't using NixOS, then you need to install the script manually.  Since
it's a single file, all you need to do is:

- Get its dependencies
- Download it

### Getting the dependencies

From least to most specific, the script requires:

- Linux
- systemd
- [A Python interpreter](https://wiki.python.org/moin/BeginnersGuide/Download) being present at `/usr/bin/python3`
- [the python systemd wrapper](https://github.com/systemd/python-systemd)

Those links should explain how to install each of those things. If you're
installing on Linux, I'd recommend starting with the second link for
distribution-specfic package instrutions.

### Downloading the script

There's several ways to do this.  The easiest, if you have git, is to clone
this repository somewhere convenient.

Otherwise, you could manually save [the script
itself](https://raw.githubusercontent.com/nicknovitski/occupado/master/occupado)
with your browser or `curl`.  Just remember to mark it as executable
afterwards:
```shell
chmod +x occupado
```

## Usage

The script will exit with status 0 if there are any sessions open, or if any
sessions have been removed in the past hour, and with status 1 otherwise.  This
means you can make a unit which halts the system on failure.

```
# occupado.service
[Unit]
OnFailure=halt.target

[Service]
Type=simple
ExecStart=/full/path/to/occupado
```

Now you need a timer to run this unit.  On AWS, since you get billed for every
hour or portion thereof, you'd want to run it every hour, a little bit before
your bill will increment.

```
# occupado.timer
[Timer]
OnBootSec=50minutes
OnUnitActiveSec=1hour
```

## Contribute

Pull requests are welcome. Feature requests too, if they come phrased as a
concrete use-case.

## License

The project license is specified in LICENSE.
