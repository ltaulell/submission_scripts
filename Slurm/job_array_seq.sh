#!/bin/bash
#
#SBATCH --job-name=array-para       # job name
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1           # 1 CPU per task
#SBATCH --mem-per-cpu=1G            # 1GiB by CPU
#SBATCH --ntasks-per-node=32        # 32 tasks per node
#SBATCH --array=1-10000%32          # 10 000 jobs, 32 jobs max in //
#SBATCH --time=0-01:00:00           # one day max

# this launch an array of 10k jobs, max 32 running, of [1 core, 1Go] each

srun script.py -index "${SLURM_ARRAY_TASK_ID}" -f input.file
