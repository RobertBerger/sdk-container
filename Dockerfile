# Copyright (C) 2015-2016 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#
# ext sdk container
#
#FROM crops/yocto:ubuntu-16.04-base
#FROM reliableembeddedsystems/yocto:ubuntu-18.04-base
FROM ubuntu:18.04

USER root

RUN apt-get update && \
    apt-get install -y \
        gawk \
        wget \
        git-core \
        subversion \
        diffstat \
        unzip \
        sysstat \
        texinfo \
        gcc-multilib \
        build-essential \
        chrpath \
        socat \
        python3 \
        xz-utils  \
        locales \
        cpio \
        screen \
        tmux \
        sudo \
        iputils-ping \
        iproute2 \
        fluxbox \
        tightvncserver && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser && \
    /usr/sbin/locale-gen en_US.UTF-8

#COPY build-install-dumb-init.sh /
#RUN  bash /build-install-dumb-init.sh && \
#     rm /build-install-dumb-init.sh && \
#     apt-get clean

#USER yoctouser
#WORKDIR /home/yoctouser
#CMD /bin/bash

#USER root

#COPY usersetup.py \
#         esdk-launch.py \
#         esdk-entry.py \
#         restrict_groupadd.sh \
#         restrict_useradd.sh \
#     /usr/bin/
#COPY sudoers.usersetup /etc/
COPY entrypoint.sh /usr/bin
#RUN chmod ugo+s /usr/bin/fix_permissions.sh

RUN apt-get -y install gosu

# hack to fix missing libs
#RUN apt-get -y install libpython3.8 libarchive13 xz-utils

# hack to fix missing libs
#COPY lib/x86_64-linux-gnu/libcrypt.so.2.0.0 /lib/x86_64-linux-gnu/libcrypt.so.2.0.0
#RUN ln -s /lib/x86_64-linux-gnu/libcrypt.so.2.0.0 /lib/x86_64-linux-gnu/libcrypt.so.2

# --> rber
RUN apt-get update && apt-get upgrade -y

# extra tools rber wants in sdk container
RUN apt-get -y install indent cppcheck vim

# extra config files rber wants in sdk container
COPY etc/skel/gitconfig /etc/skel/.gitconfig
COPY etc/skel/vimrc /etc/skel/.vimrc

# additional needed packages
RUN apt-get -y install libncursesw5-dev apt-utils


RUN apt-get -y install tree
# <-- rber

# --> rber gcc-9
RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common
#python-software-properties
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update
RUN apt-get install -y gcc g++ gcc-9 g++-9
#RUN update-alternatives --remove-all gcc
 # --> libstdc++
 # we need a libstdc++6 for this to work:
 #   build/tmp/sysroots-uninative/x86_64-linux/usr/lib/libstdc++.so.6: version `GLIBCXX_3.4.26' not found
 #   required by build/tmp/work/x86_64-linux/cmake-native/3.12.2-r0/build/Bootstrap.cmk/cmake
 # RUN apt-get upgrade -y libstdc++6
 # fix? https://www.yoctoproject.org/pipermail/yocto/2019-April/044995.html
 #      https://www.yoctoproject.org/pipermail/yocto/2016-November/033134.html
 # <-- libstdc++
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9
RUN gcc -v
# <-- rber gcc-9

# --> stuff needed to compile kernel and u-boot
RUN apt-get -y install libncurses-dev libncursesw5-dev flex bison libssl-dev bc libncurses-dev ccache
# <-- stuff needed to compile kernel and u-boot

# --> rber additional stuff needed
#RUN apt-get install -y thefuck python3-pkg-resources
# for depmod - should come from SDK:
# RUN apt-get intstall -y kmod
########################
# for kernel sphinx doc from my sdk container:
#
# to build the kernel doc manually in my docker container:
# sudo apt-get install -y python3-pip python3-venv
# sudo apt-get install -y imagemagick graphviz dvipng fonts-noto-cjk latexmk librsvg2-bin
# sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -y install texlive-xetex'
#
# cd ${HOME}/imx6q-phytec-mira-rdk-nand
# rm -rf sphinx_2.4.4
# cd ${HOME}/imx6q-phytec-mira-rdk-nand/linux-stable
# ./scripts/sphinx-pre-install
#
# /usr/bin/python3 -m venv sphinx_2.4.4
# . sphinx_2.4.4/bin/activate
#
# !!! Dependency is missing !!!
#
# pip install six
#
# make htmldocs
#
# deactivate
#######################
# <-- rber additional stuff needed

# We remove the user because we add a new one of our own.
# The usersetup user is solely for adding a new user that has the same uid,
# as the workspace. 70 is an arbitrary *low* unused uid on debian.
RUN userdel -r yoctouser
#    groupadd -g 69 usersetup && \
#    useradd -N -m -u 70 -g 69 usersetup && 
#    apt-get -y install curl sudo && \
#    echo "#include /etc/sudoers.usersetup" >> /etc/sudoers && \
#    chmod 755 /usr/bin/usersetup.py \
#        /usr/bin/esdk-launch.py \
#        /usr/bin/esdk-entry.py \
#        /usr/bin/restrict_groupadd.sh \
#        /usr/bin/restrict_useradd.sh

#RUN groupadd -g 70 sdk && \
#    useradd -N -m -u 70 -g 70 sdk && \
RUN  apt-get -y install curl sudo

#RUN groupadd -r sdk \
#  && useradd -r -g sdk sdk

# Set the locale
RUN apt-get install locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# give sdk user sudo w.o. password permissions
RUN echo "sdk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#USER sdk

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-entry.py"]
