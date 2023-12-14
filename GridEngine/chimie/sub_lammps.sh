#!/bin/bash
#
#$ -S /bin/bash
#$ -N C6_equilibration3
##$ -q E5-2670deb128B
#$ -q E5_test
#$ -pe test_debian  2
#$ -cwd
#$ -V
#$ -m be

module purge
module use /home/tjiang/modules/lmod
module load lammps/trunk

# donné par le système de batch
HOSTFILE="${TMPDIR}/machines"

if [[ -d "/scratch" ]]
then
    ### for Lake scratch / CLG* SLG* queues
    if [[ -e "/scratch/Lake/lake-gfs-scratch" ]]
    then
    	SCRATCHDIR="/scratch/Lake/${USER}/${JOB_ID}/"
    ### for E5N scratch / E5* queues
    elif [[ -e "/scratch/E5N/E5N-gfs-scratch" ]]
    then
    	SCRATCHDIR="/scratch/E5N/${USER}/${JOB_ID}/"
    ### for Chimie scratch
    elif [[ -e "/scratch/Chimie/chimie-gfs-scratch" ]]
    then
    	SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
    else
    	echo "/scratch not found, cannot create ${SCRATCHDIR}"
    	exit 1
    fi
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

# Using /tmp as scratch instead
# SCRATCHDIR="/tmp/${USER}/${JOB_ID/}"

echo "Creating scratch for this job: ${SCRATCHDIR}"
/bin/mkdir -p "${SCRATCHDIR}"

# modifier les noms des fichiers
cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }
cp -f in*.lmp data*.lmp "${SCRATCHDIR}"
#cp -f in*.lmp data*.lmp pair*.lmp "${SCRATCHDIR}"


# modifier noms des fichiers
cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }
mpirun -v -hostfile "${HOSTFILE}" -np "${NSLOTS}" lammps.sse -in in.eq.lmp > out.lmp
cp -rpf -- outputfiles_only "${SGE_O_WORKDIR}"
rm -f "${SCRATCHDIR}"