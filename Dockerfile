FROM ubuntu:20.04
MAINTAINER amaneuehara

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
WORKDIR /root

RUN apt-get update

RUN apt-get install -y \
    autoconf           \
    automake           \
    autotools-dev      \
    bc                 \
    bison              \
    build-essential    \
    curl               \
    flex               \
    gawk               \
    gperf              \
    libexpat-dev       \
    libgmp-dev         \
    libmpc-dev         \
    libmpfr-dev        \
    libtool            \
    patchutils         \
    python3            \
    texinfo            \
    unzip              \
    wget               \
    zlib1g-dev

ARG rootrepo="riscv-gnu-toolchain"
ARG hash="1af07f51a090ddb9e62ef26475b16503c1aa0358"
RUN cd $HOME && \
    wget https://github.com/riscv/${rootrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    mv ${rootrepo}-${hash} ${rootrepo}

ARG subrepo="riscv-binutils-gdb"
ARG hash="2cb5c79dad39dd438fb0f7372ac04cf5aa2a7db7"
ARG submod="riscv-binutils"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

ARG subrepo="riscv-dejagnu"
ARG hash="4ea498a8e1fafeb568530d84db1880066478c86b"
ARG submod="riscv-dejagnu"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

ARG subrepo="riscv-gcc"
ARG hash="c3911e6425f35e0722129cb30cc5ccaf3390cd75"
ARG submod="riscv-gcc"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

ARG subrepo="riscv-binutils-gdb"
ARG hash="63a44e5923c859e99d3a8799fa8132b49a135241"
ARG submod="riscv-gdb"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

ARG subrepo="riscv-glibc"
ARG hash="7395b0964db9cc4dd544926414960e9a16842180"
ARG submod="riscv-glibc"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

ARG subrepo="riscv-newlib"
ARG hash="f289cef6be67da67b2d97a47d6576fa7e6b4c858"
ARG submod="riscv-newlib"
RUN cd $HOME/${rootrepo} && \
    wget https://github.com/riscv/${subrepo}/archive/${hash}.zip && \
    unzip -q ${hash}.zip && \
    rm ${hash}.zip && \
    rmdir ${submod} && \
    mv ${subrepo}-${hash} ${submod}

RUN cd $HOME/${rootrepo} && \
    wget 'https://git.qemu.org/?p=qemu.git;a=snapshot;h=57dfc2c4d51e770ed3f617e5d1456d1e2bacf3f0;sf=tgz' -O qemu.tgz && \
    tar xfz qemu.tgz && \
    rm qemu.tgz && \
    rmdir qemu && \
    mv qemu-57dfc2c qemu

RUN cd $HOME/riscv-gnu-toolchain && rm -rf *.zip *.tgz

ENV NUMJOBS 8

RUN cd $HOME/riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv32 --with-arch=rv32ia --with-abi=ilp32

RUN cd $HOME/riscv-gnu-toolchain && \
    make linux

ENV PATH /opt/riscv32/bin:$PATH

RUN rm -rf $HOME/riscv-gnu-toolchain

RUN apt-get purge -y \
    autoconf         \
    automake         \
    autotools-dev    \
    bc               \
    bison            \
    build-essential  \
    curl             \
    flex             \
    gawk             \
    gperf            \
    libexpat-dev     \
    libgmp-dev       \
    libmpc-dev       \
    libmpfr-dev      \
    libtool          \
    patchutils       \
    python3          \
    texinfo          \
    unzip            \
    wget             \
    zlib1g-dev
