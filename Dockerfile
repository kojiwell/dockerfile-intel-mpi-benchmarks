FROM centos:7
RUN yum groupinstall -y "Development tools" \
 && yum groupinstall -y "Infiniband Support" \
 && yum install -y git wget hwloc \
 && yum clean all

# Install Intel PSM2 library
RUN yum install -y numactl numactl-devel
RUN git clone https://github.com/intel/opa-psm2.git /root/opa-psm2
WORKDIR /root/opa-psm2
RUN ./makesrpm.sh b -dir output \
 && yum install -y /root/opa-psm2/output/RPMS/x86_64/libpsm2-11.2.78-1.x86_64.rpm \
                  /root/opa-psm2/output/RPMS/x86_64/libpsm2-devel-11.2.78-1.x86_64.rpm

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
 && sed -i -e "s/^CC=mpiicc/CC=mpicc/g" \
        -e "s/^CXX=mpiicpc/CXX=mpic++/g" src_c/P2P/Makefile \
 && make all \
 && cp IMB-* /usr/local/bin

WORKDIR /tmp
