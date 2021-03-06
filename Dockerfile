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
    softhsm2 \
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

RUN wget https://www.bouncycastle.org/download/bcprov-jdk15on-159.jar
RUN wget https://www.bouncycastle.org/download/bcpkix-jdk15on-159.jar
RUN wget https://www.bouncycastle.org/download/bcmail-jdk15on-159.jar
RUN wget https://www.bouncycastle.org/download/bcpg-jdk15on-159.jar
RUN wget https://www.bouncycastle.org/download/bctls-jdk15on-159.jar
RUN wget https://www.bouncycastle.org/download/bctest-jdk15on-159.jar
RUN mv ./bcpkix-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/
RUN mv ./bcprov-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/
RUN mv ./bcmail-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/
RUN mv ./bcpg-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/
RUN mv ./bctls-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
RUN mv ./bctest-jdk15on-159.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
