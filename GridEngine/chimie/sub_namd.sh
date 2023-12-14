#!/bin/bash
#$ -S /bin/bash
#$ -N  mutm_ap-oxog
#$ -q  E5-2670gpuK20deb128
#$ -pe mpi_debian 16
#$ -cwd
#$ -V

# Loading modules to set up environment
module load NAMD/multicore+CUDA/2.12

# Setting up home and scratch directories
HOMEDIR="${SGE_O_WORKDIR}"
cd "${HOMEDIR}" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }

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
/bin/mkdir -p "${SCRATCHDIR}"
HOSTFILE="${TMPDIR}/machines"
cp "${HOSTFILE}" .  # we are supposed to be in ${HOMEDIR}
sed -i -e 's/^/host\ /' machines

# Please provide the following files for namd
CONFIGFILE="run2.namd"
TOPFILE="DDB2_CT_hmr.prmtop"
PDBFILE="DDB2_CT_run1_0.coor"
FIXFILE="DDB2_CT_new.fix"
COLVARSFILE="dihedral_run1.in"
LOGFILE="run2.out"

# Copying files to scratchdir
rsync -c "${CONFIGFILE}" "${TOPFILE}" "${PDBFILE}" "${FIXFILE}" "${COLVARSFILE}" machines runscript "${SCRATCHDIR}"

# The executables for mpirun and namd2
MPIRUN="mpirun"

# Go to scratch directory and run calculation there
cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }
echo 'group main ++shell ssh' > nodelist
cat machines >> nodelist

namd2 +idlepoll +p "${NSLOTS}" +devices 0,1 "${CONFIGFILE}" > "${LOGFILE}"

# Copy back data
rsync -c --exclude "${CONFIGFILE} ${TOPFILE} ${PDBFILE} ${COLVARSFILE}" -- * "${HOMEDIR}"
cd "${HOMEDIR}" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }

# Cleaning up scratch directory and hostfile
rm -fr "${SCRATCHDIR}"
