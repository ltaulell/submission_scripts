#!/bin/bash
#$ -S /bin/bash
#$ -N sp-LaTaS6-HSE06
#$ -q M6*,E5-2667*,E5-2670*
#$ -pe mpi16_debian 16
#$ -V
#$ -cwd

module use /home/tjiang/modules/lmod
module load crystal/17

export HOMEDIR="${SGE_O_WORKDIR}"
cd "${HOMEDIR}" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }

INPUT="LaTaS6"

if [[ -d "/scratch/Chimie" ]]
then
    export CRY17_SCRDIR="/scratch/Chimie/$USER/$JOB_ID"
elif [[ -d "/scratch/Lake" ]]
then
    export CRY17_SCRDIR="/scratch/Lake/$USER/$JOB_ID/"
elif [[ -d "/scratch/E5N" ]]
then
    export CRY17_SCRDIR="/scratch/E5N/$USER/$JOB_ID/"
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

#Use /tmp as scratch
#export CRY17_SCRDIR="/tmp/$USER/$JOB_ID"

echo "Creating scratch for this job: ${CRY17_SCRDIR}"
/bin/mkdir -p "${CRY17_SCRDIR}"
export CRY17P_MACH="${HOMEDIR}"

export MPIRUN="mpirun"
export HOSTFILE="${TMPDIR}/machines"
#export hosts="${HOMEDIR}/hosts_$(basename ${INPUT} .d12)"
cp "${HOSTFILE}" "${HOMEDIR}/machines.LINUX"
cp "${HOSTFILE}" "${HOMEDIR}/nodes.par"
#Too lazy to do a test, but the file needs to be refreshed!
#rm -f $hosts
#/bin/cat $TMPDIR/machines > $hosts
export OMP_NUM_THREADS="1"
export MKL_NUM_THREADS="1"

"${CRYSTALROOT}/utils/runmpi17" "${NSLOTS}" "${INPUT}"
#use ramdisk as scratch, only works on one node
#"${CRYSTALROOT}/utils/runmpi17SN" "${NSLOTS}" "${INPUT}"

rm -fr "${CRY17_SCRDIR}"
#rm $HOMEDIR/hosts_`basename $INPUT .d12`
