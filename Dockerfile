FROM debian:9 AS build

RUN apt-get update && apt-get install -y \
    gcc \
    cmake \
    pkg-config \
    gcc-mingw-w64 \
    libgnutls28-dev \
    perl-base \
    heimdal-dev \
    libpopt-dev \
    libglib2.0-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -o openvas-smb.tar.gz https://github.com/greenbone/openvas-smb/archive/v1.0.5.tar.gz && \
    tar xvaf openvas-smb.tar.gz && \
    cd openvas-smb-1.0.5 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && \
    mkdir /root/openvas-smb && \
    make DESTDIR=/root/openvas-smb install && \
    cd ../.. && \
    rm -rf openvas-smb-1.0.5

FROM debian:9
RUN apt-get update && apt-get install -y \
    libgnutls30 \
    libpopt0 \
    libgssapi3-heimdal \
    libhdb9-heimdal \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /root/openvas-smb /