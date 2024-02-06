# gnustep-build

This repository contains scripts for building the latest GNUstep from source under your favorite distributions.  Tested features include blocks and ARC.

See `demo.sh` and `demo-gui.sh` for barebones examples.

To install GNUstep from source, please `cd` to the directory in which you want to store GNUstep's source code, and run the following script:

```bash
wget -qO- https://raw.githubusercontent.com/ethanc8/gnustep-build/master/generic/build.sh | bash
```

If you want to customize the installation paramaters (for example, to install an older version of the libraries, to install from git `master`, or to disable the applications), please do the following:

```bash
git clone https://github.com/ethanc8/gnustep-build
nano generic/build.sh # Or your favorite text editor
./generic/build.sh
```

## TODO

* [ ] Test on more Debian derivatives
* [ ] Set up CI (GitHub Actions)
* [ ] Detect Debian derivative version
* [ ] Support non-dpkg-based distros
* [ ] Support Termux (dpkg-based, but not FHS-compliant, uses bionic libc)

<!-- ## Build Status

Platform specific build status via Github Actions (on fresh installs of the distribution using Docker):

Distribution | objc runtime | supports ARC | supports Blocks | installs clang | CI Status
-------------|-----|-----|-----|-----|:---------
Ubuntu 16.04 | 1.9 | yes | yes | 6.0 | [![Ubuntu 16.04 Build Status](https://github.com/plaurent/gnustep-build/actions/workflows/ub1604c6r19.yml/badge.svg)](https://github.com/plaurent/gnustep-build/actions/workflows/ub1604c6r19.yml)
Ubuntu 20.04 | 2.0 | yes | yes | 10.0 | [![Ubuntu 20.04 Build Status](https://github.com/plaurent/gnustep-build/actions/workflows/ub2004c10r20.yml/badge.svg)](https://github.com/plaurent/gnustep-build/actions/workflows/ub2004c10r20.yml)
Debian 10    | 2.0 | yes | yes | 8.0 |  [![Debian 10 Build Status](https://github.com/plaurent/gnustep-build/actions/workflows/deb10c8r20.yml/badge.svg)](https://github.com/plaurent/gnustep-build/actions/workflows/deb10c8r20.yml) -->
