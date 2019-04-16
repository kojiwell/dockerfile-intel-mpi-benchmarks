# Dockerfile of Intel MPI Benchmarks

How to build(e.g. MPI version 2.1.1):

```
$ docker build -t <user>/<image>:2.1.1 --build-arg MPI_SERIES=v2.1 --build-arg=2.1.1 .
$ docker push <user>/<image>:2.1.1
```

HOw to run it on HPC by Singularity:

```
$ singularity pull docker://<user>/<image>:2.1.1
$ mpirun -n 2 singularity exec <image>_2.1.1.sif IMB-MPI1 PingPong
```
