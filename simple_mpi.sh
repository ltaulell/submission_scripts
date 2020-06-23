#!/bin/bash
# $Id: simple_mpi.sh 1.3 $
#
### SGE variables begin with #$
### job's shell
#$ -S /bin/bash
### JOB_NAME (to change)
#$ -N example_openMPI
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
EXECDIR="/path/where/I/store/binaries/"

### execute program

"${MPIRUN}" -v -x LD_LIBRARY_PATH -mca btl vader,openib,self -hostfile "${HOSTFILE}" -np "${NSLOTS}" "${EXECDIR}"/SommeVecVecPAR.exe

#
