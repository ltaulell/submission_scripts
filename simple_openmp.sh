#!/bin/bash
# $Id: simple_openmp.sh 1.2 $
#
### SGE variables begin with #$
### job's shell
#$ -S /bin/bash
### JOB_NAME (to change)
#$ -N example_openMP
### queue(s) (a changer)
#$ -q h6-E5-2667v4deb128
### parallel environment & cpu numbers (NSLOTS)
### ask for full node, regardless of real CPU usage
#$ -pe openmp16 16
### load user environment for SGE
#$ -cwd
### export $ENV to exec_node
#$ -V
### emails (begin and end)
#$ -m b
#$ -m e

# go to submission directory
# important, elsewhere, program is started from ~/
cd "${SGE_O_WORKDIR}" || exit "cannot cd to ${SGE_O_WORKDIR}"

# init env (should be in ~/.profile)
source /usr/share/lmod/lmod/init/bash

### configure execution environment
module purge
module load GCC/7.2.0
#export OMP_NUM_THREADS="${NSLOTS}"  # full node
export OMP_NUM_THREADS=8  # half cpus, full mem

### execute program

./myOpenMPbinary.exe -pf param_file

#
