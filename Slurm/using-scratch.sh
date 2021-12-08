#!/bin/bash
#SBATCH --job-name=stress-max
#SBATCH --partition=Cascade
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --time=0-0:12:0 # asking for 12mn

cd "${SLURM_SUBMIT_DIR}"

# scratch example

if [[ -d "/scratch" ]]
then
    if [[ -e "/scratch/${SLURM_JOB_PARTITION}" ]]
    then
        SCRATCHDIR="/scratch/${SLURM_JOB_PARTITION}/${USER}"
        mkdir -p "${SCRATCHDIR}"
    else
        echo "/scratch not found, cannot create SCRATCHDIR"
        exit 1
    fi
else
    echo "/scratch not found, cannot create SCRATCHDIR"
    exit 1
fi

OUTFILE="${SCRATCHDIR}/${SLURM_JOB_NAME}.${SLURM_JOB_ID}.out"

echo "${SLURM_JOB_ID} - ${SLURM_JOB_NAME} / ${SLURM_JOB_USER}" >> "${OUTFILE}"
echo "${SLURM_SUBMIT_DIR} on ${SLURM_NODELIST}" >> "${OUTFILE}"
echo "--------" >> "${OUTFILE}"

sleep 600s

