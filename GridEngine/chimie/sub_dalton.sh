#!/bin/bash
#$ -S /bin/bash
#$ -N test
#$ -q E5-2670deb64A,E5-2670deb64B,E5-2670deb64C
#$ -pe mpi16_debian 16
#$ -V
#$ -cwd

## Environement (SGE, VASP, MPI)
source /usr/share/modules/init/bash
module use /home/tjiang/modules/lmod
module load dalton/2016-ompi
#module load dalton/2016-ompi-with_yttrium
#module load dalton/2016-omp

if [[ -d "/scratch/Chimie" ]]
then
    DALTON_TMPDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/Lake" ]]
then
    DALTON_TMPDIR="/scratch/Lake/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/E5N" ]]
then
    DALTON_TMPDIR="/scratch/E5N/${USER}/${JOB_ID}/"
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

dalton -t "${DALTON_TMPDIR}" -noappend -omp 16 -mb 16000 dalinp.dal moinp.mo
rm -rf "${DALTON_TMPDIR}"
