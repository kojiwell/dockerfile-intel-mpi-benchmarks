FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y build-essential openmpi-bin libopenmpi-dev git \
 && rm -rf /var/lib/apt/lists/* \
 && git clone https://github.com/intel/mpi-benchmarks.git /root/mpi-benchmarks

WORKDIR /root/mpi-benchmarks

RUN sed -i -e "s/^CC=mpiicc/CC=mpicc/g" \
        -e "s/^CXX=mpiicpc/CXX=mpic++/g" src_cpp/Makefile \
 && make all \
 && cp IMB-* /usr/local/bin

WORKDIR /tmp
