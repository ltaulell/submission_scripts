#!/bin/bash
#
## $Id: simple_mono.sh 1.5 $
#
### SGE variables begin with #$
### job's shell
#$ -S /bin/bash
### JOB_NAME (to change)
#$ -N example_job
### queue(s) (to change)
#$ -q monointel
### load user environment for SGE
#$ -cwd
### export $ENV to exec_node
#$ -V
### emails (begin and end)
#$ -m b
#$ -m e

# go to submit directory
# important, elsewhere, program is started from ~/
cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }

# init env (should be in ~/.profile)
source /usr/share/lmod/lmod/init/bash

### configure execution environment
module purge
module load Python/3.6.1

### execute program
python3 mypython3_script.py < myparam.txt > myoutput.log

#
