#!/bin/bash
#SBATCH --job-name=scratch-test
#SBATCH --partition=Cascade,Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=100M
#SBATCH --time=0-0:02:0 # asking for 2mn

# check if scratch exist, create or complain
## Cascade partition
if [[ -d "/scratch/Cascade" ]]
then
    SCRATCHDIR="/scratch/Cascade/${USER}/${JOB_ID}/"
## Lake partition (also E5-GPU)
elif [[ -d "/scratch/Chimie" ]]
then
    SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/Lake" ]]
then
    SCRATCHDIR="/scratch/Lake/${USER}/${JOB_ID}/"

else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

mkdir -p "${SCRATCHDIR:-/emptyvar}"  # won't work if var is empty

cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }

OUTFILE="${SCRATCHDIR}/${SLURM_JOB_NAME}.${SLURM_JOB_ID}.out"

# output a lot of things, SC2129
{ echo "${SLURM_JOB_ID} - ${SLURM_JOB_NAME} by ${SLURM_JOB_USER}" ;
  echo "${SLURM_SUBMIT_DIR} on ${SLURM_NODELIST}" ;
  echo "from ${SLURM_JOB_PARTITION}" ;
  echo "writing into ${OUTFILE}" ;
  echo "--------" ; } >> "${OUTFILE}"

sleep 30s

# do not forget to cleanup after job
