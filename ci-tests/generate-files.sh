#!/bin/bash

clean() {
    rm -r .github/workflows/*.yml
    rm -r ci-tests/*/
}

generate() {
    name=$1
    dockerTag=$2
    version=$3

    cat <<EOF > ".github/workflows/$name-$version.yml" 
on:
  [push]
name: $name - GNUstep $version
jobs:
  testbuild:
    name: Building GNUstep
    runs-on: ubuntu-latest
    steps:
      - name: Check out the build script repository
        uses: actions/checkout@master
      - name: Execute test script
        run: |
          docker build -t gnustep-build-ci-$name-$version ci-tests/$name-$version/.
          docker run gnustep-build-ci-$name-$version
EOF
    mkdir -p "ci-tests/$name-$version"
    cat <<EOF > "ci-tests/$name-$version/Dockerfile" 
FROM $dockerTag

RUN uname -a
RUN apt-get update && apt-get install -y clang build-essential wget git sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN git clone https://github.com/ethanc8/gnustep-build
RUN /bin/bash -c "GNUSTEP_BUILD_VERSION=$version gnustep-build/generic/build.sh"

CMD [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./gnustep-build/demo.sh" ]
EOF
}

# Creates workflows and dockerfiles given the name ($1) and docker tag ($2).
generateForOS() {
    name=$1
    dockerTag=$2

    versions=('2021may' '2023jan' '2024may' 'stable' 'trunk')

    printf "\n%s" "| $name |" >> README.md

    for version in "${versions[@]}"; do
        generate "$name" "$dockerTag" "$version"
        printf "%s" " [![$name-$version build status](https://github.com/ethanc8/gnustep-build/actions/workflows/$name-$version.yml/badge.svg)](https://github.com/ethanc8/gnustep-build/actions/workflows/$name-$version.yml) |" >> README.md
    done
}

clean

generateForOS debsid 'debian:sid'
generateForOS debtesting 'debian:testing'
# ADD NEW CODENAMES HERE
generateForOS deb12 'debian:12'
generateForOS deb11 'debian:11'
generateForOS deb10 'debian:10'

generateForOS ubudevel 'ubuntu:devel'
# ADD NEW CODENAMES HERE
generateForOS ubu2404 'ubuntu:noble'
generateForOS ubu2204 'ubuntu:jammy'
generateForOS ubu2004 'ubuntu:focal'
generateForOS ubu1804 'ubuntu:bionic'
