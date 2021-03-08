#!/bin/bash
#$ -S /bin/bash
#$ -N test-python-out 
#$ -cwd 
#$ -V
#$ -q h48-*,mono*

#set -x

source /usr/share/lmod/lmod/init/bash
module load Python/3.8.3

cd "${SGE_O_WORKDIR}"

hostname  # dans STDOUT -> ${JOB_NAME}.o${JOB_ID}

python3 test_log5+sge.py -d 

