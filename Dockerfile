FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y build-essential wget git \
 && rm -rf /var/lib/apt/lists/*


# Install OpenMPI
ARG MPI_SERIES=v4.0
ARG MPI_VERSION=4.0.1
ARG MPI_URL=https://download.open-mpi.org/release/open-mpi/${MPI_SERIES}/openmpi-${MPI_VERSION}.tar.bz2
RUN wget --quiet $MPI_URL -P /root
RUN tar jxf /root/openmpi-${MPI_VERSION}.tar.bz2 -C /root
WORKDIR /root/openmpi-${MPI_VERSION}
RUN ./configure --prefix=/usr/local --enable-orterun-prefix-by-default \
 && make \
 && make install \
 && ldconfig

# Install Intel MPI Benchmarks
RUN git clone https://github.com/intel/mpi-benchmarks.git /root/mpi-benchmarks
WORKDIR /root/mpi-benchmarks
RUN sed -i -e "s/^CC=mpiicc/CC=mpicc/g" \
        -e "s/^CXX=mpiicpc/CXX=mpic++/g" src_cpp/Makefile \
 && make all \
 && cp IMB-* /usr/local/bin

WORKDIR /tmp
