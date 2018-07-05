FROM ubuntu:xenial

RUN apt-get -y update && \
  apt-get -y install \
    autoconf \
    autoconf-archive \
    libglib2.0-dev \
    libdbus-1-dev \
    automake \
    libtool \
    autotools-dev \
    libcppunit-dev \
    p11-kit \
    libcurl4-gnutls-dev \
    libcmocka0 \
    libcmocka-dev \
    build-essential \
    git \
    pkg-config \
    vim \
    gcc \
    g++ \
    m4 \
    curl \
    wget \
    liburiparser-dev \
    libssl-dev \
    pandoc \
    opensc \
    default-jdk 

RUN apt-get -y install libgcrypt20-dev

RUN git clone https://github.com/tpm2-software/tpm2-tss.git
RUN git clone https://github.com/tpm2-software/tpm2-abrmd.git
RUN git clone https://github.com/tpm2-software/tpm2-tools.git

RUN cd tpm2-tss && \
  git checkout 1.2.0 && \
  ./bootstrap && \
  ./configure && \
  make && \
  make install

RUN cd tpm2-abrmd && \
  git checkout 1.1.1 && \
  useradd --system --user-group tss && \
  ./bootstrap && \
  ./configure --with-dbuspolicydir=/etc/dbus-1/system.d \
    --with-udevrulesdir=/etc/udev/rules.d/ \
    --with-systemdsystemunitdir=/lib/systemd/system && \
  make && \
  make install
  
RUN cd tpm2-tools && \
  git checkout 2.1.0 && \
  ./bootstrap && \
  ./configure && \
  make && \
  make install

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/tpm2.conf && \
  ldconfig

RUN git clone https://github.com/openssl/openssl.git
RUN cd openssl && \
  git checkout OpenSSL_1_1_0-stable && \
  ./config
RUN cd openssl && make
RUN cd openssl && make test
RUN cd openssl && make install
RUN apt-get -y remove --purge openssl
RUN openssl version -v
