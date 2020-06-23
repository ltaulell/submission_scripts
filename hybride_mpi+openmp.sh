#!/bin/bash
# $Id: hybride_mpi+openmp.sh 1.4 $
#
### SGE variables begin with #$
### job's shell
#$ -S /bin/bash
### JOB_NAME (to change)
#$ -N example_openMPI+OpenMP
### queue(s) (to change)
#$ -q h6-E5-2667v4deb128
### parallel environment & cpu numbers (NSLOTS)
### in this example, asking for two nodes
#$ -pe openmp16 32
### load user environment for SGE
#$ -cwd
### export ENV to all exec_nodes
#$ -V
### emails (begin and end)
#$ -m b
#$ -m e

# given by SGE
HOSTFILE="${TMPDIR}/machines"

# go to submission directory
# important, elsewhere, program is started from ~/
cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }

# init env (should be in ~/.profile)
source /usr/share/lmod/lmod/init/bash

### configure environment
module purge
module load GCC/7.2.0/OpenMPI/3.0.0 

### force OpenMPI variables
PREFIX="/applis/PSMN/debian9/software/Compiler/GCC/7.2.0/OpenMPI/3.0.0/"
MPIRUN="${PREFIX}/bin/mpirun"
EXECDIR="/path/where/I/store/binaries"

### OpenMP behavior
export OMP_NUM_THREADS=8

### execute program
# 2 mpi x 8 openMP = 16c / node (bi-socket 8 cores)

"${MPIRUN}" -v -prefix "${PREFIX}" -mca btl vader,openib,self -hostfile "${HOSTFILE}" -np 2  -bind-to socket -npersocket 1  "${EXECDIR}"/ProgPAR_OpenMP_MPI.c.exe

#
