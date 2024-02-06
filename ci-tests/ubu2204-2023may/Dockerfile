FROM ubuntu:focal

RUN uname -a
RUN apt-get update && apt-get install -y clang build-essential wget git sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN git clone https://github.com/ethanc8/gnustep-build
RUN /bin/bash -c "GNUSTEP_BUILD_VERSION=2023may gnustep-build/generic/build.sh"

CMD [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./gnustep-build/demo.sh" ]
