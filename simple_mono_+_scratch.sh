#!/bin/bash
# $Id: simple_mono_+_scratch.sh 1.1 $
#
### SGE variables begin with #$
### job's shell
#$ -S /bin/bash
### JOB_NAME (to change)
#$ -N example_job
### queue(s) (to change)
#$ -q monointeldeb128
### load user environment for SGE
#$ -cwd
### export $ENV to exec_node
#$ -V
### emails (begin and end)
#$ -m b
#$ -m e

# go to submit directory
# important, elsewhere, program is started from ~/
cd ${SGE_O_WORKDIR}

# init env (should be in ~/.profile)
source /usr/share/lmod/lmod/init/bash

### configure execution environment
module purge
module load Python/3.6.1

### definition SCRATCHDIR
### refer to PSMN cluster's documentation for scratchs list
SCRATCH="/scratch/E5N"
### subsitute $HOME by $SCRATCH in path
SCRATCHDIR=${SGE_O_WORKDIR/"${HOME}"/"${SCRATCH}"}
### output SCRATCHDIR to logs (debug)
echo "SCRATCHDIR=${SCRATCHDIR}"

### create new workdir in /scratch
if [[ ! -d "${SCRATCHDIR}" ]]
then
   /bin/mkdir -p ${SCRATCHDIR}
fi

### copy workfiles into scratch workdir (example: all of it)
/bin/cp ${SGE_O_WORKDIR}/* ${SCRATCHDIR}/

### go to scratch working directory
cd ${SCRATCHDIR}

### execute program
mypython3_script.py < myparam.txt > myoutput.log

### retrieve results into $HOME
/bin/cp ${SCRATCHDIR}/myoutput.log ${SGE_O_WORKDIR}/

### cleanup scratch workdir
rm -fr ${SCRATCHDIR}

#
