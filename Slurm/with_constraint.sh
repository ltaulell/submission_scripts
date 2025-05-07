#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --constraint=local_scratch  # only nodes with features="local_scratch"
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

ls /scratch/

# Be aware: local scratch may be reserved to some groups
# or available to all users (See PSMN documentation).
# files older than 120 days are automaticaly erased.

