<!-- SPDX-License-Identifier: Apache-2.0 -->

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
* [x] Set up CI (GitHub Actions)
  * [ ] Make it pass on all configurations
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

## Build Status

| Distribution | 2021may | 2023jan | stable | trunk |
| ------------ | ------- | ------- | ------ | ----- |
| debsid | [![debsid-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-2021may.yml) | [![debsid-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-2023jan.yml) | [![debsid-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-stable.yml) | [![debsid-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debsid-trunk.yml) |
| debtesting | [![debtesting-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-2021may.yml) | [![debtesting-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-2023jan.yml) | [![debtesting-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-stable.yml) | [![debtesting-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/debtesting-trunk.yml) |
| deb12 | [![deb12-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-2021may.yml) | [![deb12-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-2023jan.yml) | [![deb12-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-stable.yml) | [![deb12-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb12-trunk.yml) |
| deb11 | [![deb11-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-2021may.yml) | [![deb11-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-2023jan.yml) | [![deb11-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-stable.yml) | [![deb11-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb11-trunk.yml) |
| deb10 | [![deb10-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-2021may.yml) | [![deb10-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-2023jan.yml) | [![deb10-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-stable.yml) | [![deb10-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/deb10-trunk.yml) |
| ubudevel | [![ubudevel-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-2021may.yml) | [![ubudevel-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-2023jan.yml) | [![ubudevel-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-stable.yml) | [![ubudevel-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubudevel-trunk.yml) |
| ubu2310 | [![ubu2310-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-2021may.yml) | [![ubu2310-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-2023jan.yml) | [![ubu2310-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-stable.yml) | [![ubu2310-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2310-trunk.yml) |
| ubu2204 | [![ubu2204-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-2021may.yml) | [![ubu2204-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-2023jan.yml) | [![ubu2204-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-stable.yml) | [![ubu2204-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2204-trunk.yml) |
| ubu2004 | [![ubu2004-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-2021may.yml) | [![ubu2004-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-2023jan.yml) | [![ubu2004-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-stable.yml) | [![ubu2004-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu2004-trunk.yml) |
| ubu1804 | [![ubu1804-2021may build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-2021may.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-2021may.yml) | [![ubu1804-2023jan build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-2023jan.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-2023jan.yml) | [![ubu1804-stable build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-stable.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-stable.yml) | [![ubu1804-trunk build status](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-trunk.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/ubu1804-trunk.yml) |