#!/bin/bash
#$ -S /bin/bash
#$ -N Orca
#$ -cwd
#$ -V
#$ -q  E5-2667v4deb256A,E5-2697Av4deb256,M6*,E5-2670deb256*
#$ -pe mpi32_debian 32

module use /home/tjiang/modules/lmod
module load orca/4_0_1_2_linux_x86-64_openmpi202

input="RuExtrap.inp"
output=$(basename "${input}" .inp).out

if [[ -d "/scratch/Chimie" ]]
then
    SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/Lake" ]]
then
    SCRATCHDIR="/scratch/Lake/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/E5N" ]]
then
    SCRATCHDIR="/scratch/E5N/${USER}/${JOB_ID}/"

else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi
echo "Creating scratch for this job: ${SCRATCHDIR}"
mkdir -p "${SCRATCHDIR}"

cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }
cp "${input}"  "${SCRATCHDIR}"
cd  "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }
/home/tjiang/softs/orca/4_0_1_2_linux_x86-64_openmpi202/orca "${input}" > "${SGE_O_WORKDIR}/${output}"
cp -- outputfiles_only "${SGE_O_WORKDIR}"
cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }
rm -rf "${SCRATCHDIR}"
