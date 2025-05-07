#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

# See also using_scratch_naive.sh

# my binary lie in my home, absolute path
MYBIN="${HOME}/bin/myprogram"

# but I want to work in scratch
# Lake-short partition, absolute path, including login and job ID, trailing /
SCRATCHDIR="/scratch/Lake/${USER}/${SLURM_JOB_ID}/"

# if it doesn't exist, create
if [[ ! -d "${SCRATCHDIR}" ]]
then
   /bin/mkdir -p "${SCRATCHDIR}"
fi

# go to scratch, exit script if error
cd ${SCRATCHDIR} || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }

# I work in ${SCRATCHDIR}, relative path (input is NOT in ${SLURM_JOB_ID}/)
${MYBIN} < ../input > output

