#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5-GPU
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --gpu-bind=verbose,single:1
#SBATCH --cpus-per-gpu=1
#SBATCH --mem-per-cpu=12G           # good practice to match GPU mem
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

env
echo "--- *** --- *** ---"
nvidia-smi

# usable GPU devices will be listed (comma separated list) in both
# CUDA_VISIBLE_DEVICES and GPU_DEVICE_ORDINAL, if you need their id (0 or 1)

