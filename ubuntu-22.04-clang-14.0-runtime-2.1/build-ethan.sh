#!/bin/bash

set -x

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

# Set to true to also build and install apps
APPS=true

# Set to true to pause after each build to verify successful build and installation
PROMPT=false

# Install Requirements
sudo apt update

echo -e "\n\n${GREEN}Installing dependencies...${NC}"

sudo apt-get update
sudo apt -y install clang-14 build-essential wget git subversion cmake libffi-dev libxml2-dev \
libgnutls28-dev libicu-dev libblocksruntime-dev libkqueue-dev libpthread-workqueue-dev autoconf libtool \
libjpeg-dev libtiff-dev libffi-dev libcairo-dev libx11-dev libxt-dev libxft-dev libxrandr-dev \
libicu-dev libicu70

if [ "$APPS" = true ] ; then
  sudo apt -y install curl
fi

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
git clone https://github.com/apple/swift-corelibs-libdispatch --depth=1 --branch swift-5.7-RELEASE
#cd swift-corelibs-libdispatch
#  git checkout swift-5.2.2-RELEASE
#cd ..
git clone https://github.com/gnustep/libobjc2.git --branch v2.1
cd libobjc2
  git submodule init
  git submodule sync
  git submodule update
cd ..
git clone https://github.com/gnustep/tools-make.git --branch make-2_9_0
git clone https://github.com/gnustep/libs-base.git --branch base-1_28_0
git clone https://github.com/gnustep/libs-corebase.git
git clone https://github.com/gnustep/libs-gui.git --branch gui-0_29_0
git clone https://github.com/gnustep/libs-back.git --branch back-0_29_0

if [ "$APPS" = true ] ; then
  git clone https://github.com/gnustep/apps-projectcenter.git
  git clone https://github.com/gnustep/apps-gorm.git
  # It looks like a lot of bugfixes and improvements have landed since 1.2.28
  # and the 1.2.28 release wasn't conducted properly.
  # cd apps-gorm
  #   # Checkout 1.2.28
  #   git checkout f97cfac1c8d30b8662cdec03e6f1340140b7e90f
  # cd ..
  svn co http://svn.savannah.nongnu.org/svn/gap/trunk/libs/PDFKit/
  git clone https://github.com/gnustep/apps-gworkspace.git
  cd apps-gworkspace
    # Checkout 1.0.0
    git checkout 0e5bca27f77156cf1800b548732fc917e6a22ddb
  cd ..
  git clone https://github.com/gnustep/apps-systempreferences.git
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

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
echo ". /usr/GNUstep/System/Library/Makefiles/GNUstep.sh" >> ~/.bashrc
echo "export RUNTIME_VERSION=$RUNTIME_VERSION" >> ~/.bashrc
echo 'export CXXFLAGS="-std=c++11"' >> ~/.bashrc


showPrompt

# Build libdispatch
echo -e "\n\n"
echo -e "${GREEN}Building libdispatch...${NC}"
cd ../swift-corelibs-libdispatch
rm -Rf build
mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=${CC} \
-DCMAKE_CXX_COMPILER=${CXX} \
-DCMAKE_BUILD_TYPE=Release \
-DUSE_GOLD_LINKER=YES
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
cmake ../ -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_ASM_COMPILER=$CC -DTESTS=OFF
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

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

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
CFLAGS=`gnustep-config --objc-flags` ./configure
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

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

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

echo -e "\n\n"
echo -e "${GREEN}Install is done. Open a new terminal to start using.${NC}"
