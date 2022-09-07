#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5-GPU
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-gpu=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

env > env-E5-GPU.txt
echo "--- *** --- *** ---"
nvidia-smi

