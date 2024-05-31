#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

set -x

# Set version numbers
# Possible values: trunk, stable, 2023jan, 2021may, custom
# If you specify custom, you must specify all other variables
if [[ -n "$GNUSTEP_BUILD_VERSION" ]]; then
  VERSION="$GNUSTEP_BUILD_VERSION"
else
  VERSION="stable"
fi

# Set to true to also build and install apps
if [[ -n "$GNUSTEP_BUILD_APPS" ]]; then
  APPS="$GNUSTEP_BUILD_APPS"
else
  APPS=true
fi

# Set to true to also build and install themes
if [[ -n "$GNUSTEP_BUILD_THEMES" ]]; then
  THEMES="$GNUSTEP_BUILD_THEMES"
else
  THEMES=true
fi

# Set to true to pause after each build to verify successful build and installation
if [[ -n "$GNUSTEP_BUILD_PROMPT" ]]; then
  PROMPT="$GNUSTEP_BUILD_PROMPT"
else
  PROMPT=false
fi

if [[ $VERSION = "stable" ]]; then
  LIBDISPATCH_VERSION=swift-5.10-RELEASE
  LIBOBJC2_VERSION=v2.2.1
  GSMAKE_VERSION=make-2_9_2
  GSBASE_VERSION=base-1_30_0
  GSCOREBASE_VERSION=master # No releases
  GSGUI_VERSION=gui-0_31_0
  GSBACK_VERSION=back-0_31_0
  PROJECTCENTER_VERSION=projectcenter-0_7_0 # 2023-Feb, only stable release in past 9 years
  GORM_VERSION=gorm-1_4_0
  GWORKSPACE_VERSION=master # v1.0.0 is pretty old
  SYSTEMPREFERENCES_VERSION=master
elif [[ $VERSION = "2023jan" ]]; then
  LIBDISPATCH_VERSION=swift-5.7.1-RELEASE
  LIBOBJC2_VERSION=v2.1
  GSMAKE_VERSION=make-2_9_1
  GSBASE_VERSION=base-1_29_0
  GSCOREBASE_VERSION=master
  GSGUI_VERSION=gui-0_30_0
  GSBACK_VERSION=back-0_30_0
  PROJECTCENTER_VERSION=projectcenter-0_7_0 # 2023-Feb, only stable release in past 9 years
  GORM_VERSION=gorm-1_3_1
  GWORKSPACE_VERSION=gworkspace-1_0_0 # Commit 0e5bca2
  SYSTEMPREFERENCES_VERSION=master
elif [[ $VERSION = "2021may" ]]; then
  LIBDISPATCH_VERSION=swift-5.4.3-RELEASE # Bugfix for Swift 5.4.1
  LIBOBJC2_VERSION=v2.1
  GSMAKE_VERSION=make-2_9_1 # Bugfix for make-2_9_0
  GSBASE_VERSION=base-1_28_1 # Bugfix for base-1_28_0
  GSCOREBASE_VERSION=master # No releases
  GSGUI_VERSION=gui-0_29_0
  GSBACK_VERSION=back-0_29_0
  PROJECTCENTER_VERSION=projectcenter-0_7_0 # 2023-Feb, only stable release in past 9 years
  GORM_VERSION=gorm-1_2_28 # Commit f97cfac
  GWORKSPACE_VERSION=gworkspace-1_0_0 # 2021-Dec, only stable release in past 7 years
  SYSTEMPREFERENCES_VERSION=master
elif [[ $VERSION = "2024may" ]]; then
  LIBDISPATCH_VERSION=swift-5.10-RELEASE
  LIBOBJC2_VERSION=v2.2.1
  GSMAKE_VERSION=make-2_9_2
  GSBASE_VERSION=base-1_30_0
  GSCOREBASE_VERSION=master # No releases
  GSGUI_VERSION=gui-0_31_0
  GSBACK_VERSION=back-0_31_0
  PROJECTCENTER_VERSION=projectcenter-0_7_0 # 2023-Feb, only stable release in past 9 years
  GORM_VERSION=gorm-1_4_0
  GWORKSPACE_VERSION=master # v1.0.0 is pretty old
  SYSTEMPREFERENCES_VERSION=master
elif [[ $VERSION = "custom" ]]; then
  :
elif [[ $VERSION = "trunk" ]]; then
  LIBDISPATCH_VERSION=swift-5.9.2-RELEASE
  LIBOBJC2_VERSION=master # v2.2 once the release is finished
  GSMAKE_VERSION=master
  GSBASE_VERSION=master
  GSCOREBASE_VERSION=master
  GSGUI_VERSION=master
  GSBACK_VERSION=master
  PROJECTCENTER_VERSION=master
  GORM_VERSION=master
  GWORKSPACE_VERSION=master # 1.0.0 is pretty old
  SYSTEMPREFERENCES_VERSION=master
else
  echo "$VERSION is not a supported version"
  exit 1
fi

# Show prompt function
function showPrompt()
{
  if [ "$PROMPT" = true ] ; then
    echo -e "\n\n"
    read -p "${GREEN}Press enter to continue...${NC}"
  fi
}

# Set colors
GREEN=`tput setaf 2`
NC=`tput sgr0` # No Color

# Determine OS
if [[ -f "/etc/debian_version" ]]; then
  OS_IS_DEBIAN_DERIVATIVE=true
else
  OS_IS_DEBIAN_DERIVATIVE=false
  echo "WARNING: You are not on a Debian derivative!"
fi

debianPackageIsInstalled() { pkg=$1
  status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
  if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
    return 1 # false
  else
    return 0 # true
  fi
}

# Allow comparing the Debian or Ubuntu releases
monthOfDebianUbuntuCodename() { codename=$1
  case "$codename" in
    # Debian releases by full freeze
    sid) echo 99999 ;;
    forky) echo 2705 ;; # Assumed
    trixie) echo 2505 ;; # Assumed
    bookworm) echo 2305 ;;
    bullseye) echo 2107 ;;
    buster) echo 1903 ;;
    stretch) echo 1702 ;;
    jessie) echo 1411 ;;
    # Ubuntu releases by release date
    noble) echo 2404 ;;
    mantic) echo 2310 ;;
    lunar) echo 2304 ;;
    kinetic) echo 2210 ;;
    jammy) echo 2204 ;;
    impish) echo 2110 ;;
    hirsute) echo 2104 ;;
    groovy) echo 2010 ;;
    focal) echo 2004 ;;
    eoan) echo 1910 ;;
    disco) echo 1904 ;;
    cosmic) echo 1810 ;;
    bionic) echo 1804 ;;
    artful) echo 1710 ;;
    zesty) echo 1704 ;;
    yakkety) echo 1610 ;;
    xenial) echo 1604 ;;
    # Assume any other release is new
    *) echo 99999 ;;
  esac
}

if $OS_IS_DEBIAN_DERIVATIVE; then
  DEBIAN_UBUNTU_CODENAME=$( \
   (grep UBUNTU_CODENAME /etc/os-release || \
    grep DISTRIB_CODENAME /etc/upstream-release/lsb-release || \
    grep DISTRIB_CODENAME /etc/lsb-release || \
    grep VERSION_CODENAME /etc/os-release) 2>/dev/null | \
   cut -d'=' -f2 )
  # ADD NEW CODENAMES HERE
  # Currently has Ubuntu 16.04~24.04 and Debian Jessie (15.04) to Trixie (25.??), plus Testing and Sid
  if [[ ! "$DEBIAN_UBUNTU_CODENAME" =~ ^(xenial|yakkety|zesty|artful|bionic|cosmic|disco|eoan|focal|groovy|hirsute|impish|jammy|kinetic|lunar|mantic|noble|jessie|stretch|buster|bullseye|bookworm|trixie|forky|sid)$ ]]; then
    DEBIAN_UBUNTU_CODENAME=$(cut -d'/' -f1 < /etc/debian_version)
  fi
  echo "It looks like we're on a Debian derivative with codename $DEBIAN_UBUNTU_CODENAME."

  # ADD NEW CODENAMES HERE (UBUNTU ONLY)
  if [[ ! "$DEBIAN_UBUNTU_CODENAME" =~ ^(xenial|yakkety|zesty|artful|bionic|cosmic|disco|eoan|focal|groovy|hirsute|impish|jammy|kinetic|lunar|mantic|noble)$ ]]; then
    OS_IS_UBUNTU_DERIVATIVE=true
  else
    OS_IS_UBUNTU_DERIVATIVE=false
  fi

  ## ADD NEW LLVM VERSIONS HERE
  month="$(monthOfDebianUbuntuCodename "$DEBIAN_UBUNTU_CODENAME")"
  if [[ "$month" -ge 2004 && "$month" -le 2210 || "$month" -eq 1903 || "$month" -eq 1702 ]]; then
    HAS_CLANG_11_IN_REPO=true
  else
    HAS_CLANG_11_IN_REPO=false
  fi
  # Clang 12 was only available in Sid for a limited period.
  if [[ $OS_IS_UBUNTU_DERIVATIVE && "$month" -ge 2104 && "$month" -le 2204 ]]; then
    HAS_CLANG_12_IN_REPO=true
  else
    HAS_CLANG_12_IN_REPO=false
  fi
  # Note: Clang 13 is also in focal-proposed.
  if [[ "$(monthOfDebianUbuntuCodename "$DEBIAN_UBUNTU_CODENAME")" -ge 2107 ]]; then
    HAS_CLANG_13_IN_REPO=true
  else
    HAS_CLANG_13_IN_REPO=false
  fi
  if [[ "$(monthOfDebianUbuntuCodename "$DEBIAN_UBUNTU_CODENAME")" -ge 2204 ]]; then
    HAS_CLANG_14_IN_REPO=true
  else
    HAS_CLANG_14_IN_REPO=false
  fi
fi

# Install Requirements
echo -e "\n\n${GREEN}Installing dependencies...${NC}"

if $OS_IS_DEBIAN_DERIVATIVE; then
  # If we're in a VM without tzdata, then install tzdata.
  if ! debianPackageIsInstalled tzdata; then
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo -E apt -y install tzdata
  fi
  DEBIAN_FRONTEND=noninteractive sudo -E apt -y install wget curl software-properties-common

  sudo apt update
  if $OS_IS_UBUNTU_DERIVATIVE; then
    sudo add-apt-repository universe
    # Some LLVM packages depend on newer GCC toolchains
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
  fi

  if $HAS_CLANG_14_IN_REPO; then
    :
  else
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh 14
  fi

  DEBIAN_FRONTEND=noninteractive sudo -E apt -y install gobjc++ clang-14 liblldb-14 lld-14 build-essential git subversion \
  libc6 libc6-dev \
  libxml2 libxml2-dev \
  libffi-dev \
  libicu-dev icu-devtools \
  libuuid1 uuid-dev uuid-runtime \
  libsctp1 libsctp-dev lksctp-tools \
  libavahi-core7 libavahi-core-dev \
  libavahi-client3 libavahi-client-dev \
  libavahi-common3 libavahi-common-dev libavahi-common-data \
  libgcrypt20 libgcrypt20-dev \
  libbsd0 libbsd-dev \
  util-linux-locales \
  locales-all \
  libjpeg-dev \
  libtiff-dev \
  libcups2-dev \
  libfreetype6-dev \
  libcairo2-dev \
  libxt-dev \
  libgl1-mesa-dev \
  libpcap-dev \
  libc-dev libc++-dev libc++1 \
  python3-dev swig \
  libedit-dev \
  binfmt-support libtinfo-dev \
  bison flex m4 wget \
  libicns1 libicns-dev \
  libxslt1.1 libxslt1-dev \
  libxft2 libxft-dev \
  libflite1 flite1-dev \
  libxmu6 libxpm4 wmaker-common \
  libgnutls30 libgnutls28-dev \
  libpng-dev libpng16-16 \
  default-libmysqlclient-dev \
  libpq-dev \
  libgif7 libgif-dev libwings3 libwings-dev \
  libwraster-dev libwutil5 \
  libcups2-dev \
  xorg \
  libfreetype6 libfreetype6-dev \
  libpango1.0-dev \
  libcairo2-dev \
  libxt-dev libssl-dev \
  libasound2-dev libjack-dev libjack0 libportaudio2 \
  libportaudiocpp0 portaudio19-dev \
  cmake libxrandr-dev libcurl4-gnutls-dev libcurl4

  # readline-common libreadline7 libreadline-dev cmake-curses-gui
fi # if $OS_IS_DEBIAN_DERIVATIVE

# Create build directory
mkdir GNUstep-build
cd GNUstep-build

# Set clang as compiler
export CC=clang-14
export CXX=clang++-14
export CXXFLAGS="-std=c++11"
export RUNTIME_VERSION=gnustep-2.1
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LD=/usr/bin/ld.gold
export LDFLAGS="-fuse-ld=/usr/bin/ld.gold -L/usr/local/lib"


# Checkout sources
echo -e "\n\n${GREEN}Checking out sources...${NC}"
git clone https://github.com/apple/swift-corelibs-libdispatch --depth=1 --branch $LIBDISPATCH_VERSION
#cd swift-corelibs-libdispatch
#  git checkout swift-5.2.2-RELEASE
#cd ..
git clone https://github.com/gnustep/libobjc2.git --branch $LIBOBJC2_VERSION
cd libobjc2
  git submodule init
  git submodule sync
  git submodule update
cd ..
git clone https://github.com/gnustep/tools-make.git --branch $GSMAKE_VERSION
git clone https://github.com/gnustep/libs-base.git --branch $GSBASE_VERSION
git clone https://github.com/gnustep/libs-corebase.git --branch $GSCOREBASE_VERSION
git clone https://github.com/gnustep/libs-gui.git --branch $GSGUI_VERSION
git clone https://github.com/gnustep/libs-back.git --branch $GSBACK_VERSION

if [ "$APPS" = true ] ; then
  git clone https://github.com/gnustep/apps-projectcenter.git --branch $PROJECTCENTER_VERSION
  
  if [[ $GORM_VERSION == "gorm-1_2_28" ]]; then
    git clone https://github.com/gnustep/apps-gorm.git
    cd apps-gorm
      # Checkout 1.2.28
      git checkout f97cfac1c8d30b8662cdec03e6f1340140b7e90f
    cd ..
  else
    git clone https://github.com/gnustep/apps-gorm.git --branch $GORM_VERSION
  fi
  svn co http://svn.savannah.nongnu.org/svn/gap/trunk/libs/PDFKit/
  
  if [[ $GWORKSPACE_VERSION == "gworkspace-1_0_0" ]]; then
    git clone https://github.com/gnustep/apps-gworkspace.git
    cd apps-gworkspace
      # Checkout 1.0.0
      git checkout 0e5bca27f77156cf1800b548732fc917e6a22ddb
    cd ..
  else
    git clone https://github.com/gnustep/apps-gworkspace.git --branch $GWORKSPACE_VERSION
  fi
  git clone https://github.com/gnustep/apps-systempreferences.git --branch $SYSTEMPREFERENCES_VERSION
fi

if [ "$THEMES" = true ] ; then
  git clone https://github.com/BertrandDekoninck/NarcissusRik.git
  git clone https://github.com/BertrandDekoninck/NesedahRik.git
fi

set -e
showPrompt

# Build GNUstep make first time
echo -e "\n\n"
echo -e "${GREEN}Building GNUstep-make for the first time...${NC}"
cd tools-make
# git checkout `git rev-list -1 --first-parent --before=2017-04-06 master` # fixes segfault, should probably be looked at.
#./configure --enable-debug-by-default --with-layout=gnustep  --enable-objc-arc  --with-library-combo=ng-gnu-gnu
CC=$CC ./configure \
  --with-layout=gnustep \
  --disable-importing-config-file \
  --enable-native-objc-exceptions \
  --enable-objc-arc \
  --enable-install-ld-so-conf \
  --with-library-combo=ng-gnu-gnu

make -j8
sudo -E make install

source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
echo "source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh" >> ~/.bashrc
echo "export RUNTIME_VERSION=$RUNTIME_VERSION" >> ~/.bashrc
echo 'export CXXFLAGS="-std=c++11"' >> ~/.bashrc


showPrompt

# Build libdispatch
echo -e "\n\n"
echo -e "${GREEN}Building libdispatch...${NC}"
cd ../swift-corelibs-libdispatch
rm -Rf build
mkdir build && cd build
cmake ../ \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_ASM_COMPILER=${CC} \
  -DCMAKE_LINKER=${LD} \
  -DUSE_GOLD_LINKER=YES \
  -DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}" \
  -DTESTS=OFF
make
sudo -E make install
sudo ldconfig

showPrompt

# Build libobjc2
echo -e "\n\n"
echo -e "${GREEN}Building libobjc2...${NC}"
cd ../../libobjc2
rm -Rf build
mkdir build && cd build
cmake ../ \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_ASM_COMPILER=${CC} \
  -DCMAKE_LINKER=${LD} \
  -DUSE_GOLD_LINKER=YES \
  -DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}" \
  -DTESTS=OFF
cmake --build .
sudo -E make install
sudo ldconfig

showPrompt

# Build GNUstep make second time
echo -e "\n\n"
echo -e "${GREEN}Building GNUstep-make for the second time...${NC}"
cd ../../tools-make
#./configure --enable-debug-by-default --with-layout=gnustep --enable-objc-arc --with-library-combo=ng-gnu-gnu
CC=$CC ./configure \
  --with-layout=gnustep \
  --disable-importing-config-file \
  --enable-native-objc-exceptions \
  --enable-objc-arc \
  --enable-install-ld-so-conf \
  --with-library-combo=ng-gnu-gnu

make -j8
sudo -E make install
sudo ldconfig

source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

showPrompt

# Build GNUstep base
echo -e "\n\n"
echo -e "${GREEN}Building GNUstep-base...${NC}"
cd ../libs-base/
./configure
make -j8
sudo -E make install

showPrompt

# Build GNUstep corebase
echo -e "\n\n"
echo -e "${GREEN}Building GNUstep corebase (set CFLAGS)...${NC}"
cd ../libs-corebase
CFLAGS=$(gnustep-config --objc-flags) ./configure
make -j8
sudo -E make install
sudo ldconfig

showPrompt

# Build GNUstep GUI
echo -e "\n\n"
echo -e "${GREEN} Building GNUstep-gui...${NC}"
cd ../libs-gui
./configure
make -j8
sudo -E make install

showPrompt

# Build GNUstep back
echo -e "\n\n"
echo -e "${GREEN}Building GNUstep-back...${NC}"
cd ../libs-back
./configure
make -j8
sudo -E make install

showPrompt

source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

if [ "$APPS" = true ] ; then
  echo -e "${GREEN}Building ProjectCenter...${NC}"
  cd ../apps-projectcenter/
  make -j8
  sudo -E make install

  showPrompt

  echo -e "${GREEN}Building Gorm...${NC}"
  cd ../apps-gorm/
  make -j8
  sudo -E make install

  showPrompt

  echo -e "${GREEN}Building PDFKit...${NC}"
  cd ../PDFKit/
  ./configure
  make -j8
  sudo -E make install

  showPrompt

  echo -e "\n\n"
  echo -e "${GREEN}Building GWorkspace...${NC}"
  cd ../apps-gworkspace/
  ./configure
  make -j8
  sudo -E make install

  showPrompt

  echo -e "\n\n"
  echo -e "${GREEN}Building SystemPreferences...${NC}"
  cd ../apps-systempreferences/
  make -j8
  sudo -E make install

fi

if [ "$THEMES" = true ] ; then

  showPrompt

  echo -e "\n\n"
  echo -e "${GREEN}Installing NesedahRik.theme...${NC}"
  cd ../NesedahRik/
  sudo cp -R NesedahRik.theme /usr/GNUstep/Local/Library/Themes/

  showPrompt

  echo -e "\n\n"
  echo -e "${GREEN}Installing NarcissusRik.theme...${NC}"
  cd ../NarcissusRik/
  sudo cp -R NarcissusRik.theme /usr/GNUstep/Local/Library/Themes/

fi

echo -e "\n\n"
echo -e "${GREEN}Install is done. Open a new terminal to start using.${NC}"
