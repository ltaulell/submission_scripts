#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5-GPU
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1           # or more
#SBATCH --gres=gpu:2
#SBATCH --cpus-per-gpu=1
#SBATCH --gpu-bind=verbose,single:1 # bind each process to its own GPU (single:<tasks_per_gpu>)
#SBATCH --gpus-per-task=1           # equivalent of --gpu-bind=per_task,single
#SBATCH --mem-per-cpu=12G           # good practice to match GPU mem
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH -o ./%N.%j.%x.out           # output
#SBATCH -e ./%N.%j.%x.err           # errors
# with:
# %N = nodename
# %x = jobname
# %j = jobid

#env  # for heavy debug purpose
echo "--- *** --- *** ---"
nvidia-smi -L  # usable device

# usable GPU devices will be listed (comma separated list) in both
# CUDA_VISIBLE_DEVICES and GPU_DEVICE_ORDINAL, if you need their id (0 or 1)

echo "cuda visible devices: ${CUDA_VISIBLE_DEVICES}"
echo "gpu device ordinal: ${GPU_DEVICE_ORDINAL}"
echo "slurm allocated gpu: ${SLURM_JOB_GPUS}"
