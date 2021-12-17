#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=1           # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

echo "${ENV}" > env-E5.txt

