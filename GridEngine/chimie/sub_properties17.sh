#!/bin/bash
#$ -S /bin/bash
#$ -N  LTS6-eff-mass
#$ -q  monointeldeb48,monointeldeb128,r820deb768
#$ -V
#$ -cwd

module use /home/tjiang/modules/lmod
module load crystal/17

export HOMEDIR="${SGE_O_WORKDIR}"
cd "${HOMEDIR}" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }
export CRY17_INP="${HOMEDIR}"
 
if [[ -d "/scratch/Chimie" ]]
then
    export CRY17_SCRDIR="/scratch/Chimie/${USER}/${JOB_ID}"
elif [[ -d "/scratch/Lake" ]]
then
    export CRY17_SCRDIR="/scratch/Lake/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/E5N" ]]
then
    export CRY17_SCRDIR="/scratch/E5N/${USER}/${JOB_ID}/"
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

echo "Creating scratch for this job: ${CRY17_SCRDIR}"
/bin/mkdir -p "${CRY17_SCRDIR}"
export EXEC="${CRYSTALROOT}/utils/runprop17"

# Running crystal properties
# You should provide the name of .d3 and .f9 files, excluding the extension
# i.e., if there exist tmp1.d3 and tmp2.f9, then the command for running
# crystal properties should look like
# $EXEC tmp1 tmp2
$EXEC LaTaS6 LaTaS6

# Cleaning up scratch directory
rm -fr "${CRY17_SCRDIR}"
