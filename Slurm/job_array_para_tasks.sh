#!/bin/bash
#
#SBATCH --job-name=array-para     # Nom du Job
#SBATCH --cpus-per-task=16        # 16 CPU per task (~ OMP_NUM_THREADS=16)
#SBATCH --array=1-5000%8          # 5000 Jobs, 8 max in parallel
#SBATCH --partition=E5
#SBATCH --mem-per-cpu=4G            # 4GiB by CPU (64G per task)
#SBATCH --ntasks-per-node=1         # 1 task per node
#SBATCH --time=0-01:00:00           # one day max

# this launch an array of 5000 jobs, max 8 running, of [16 cores, 64Go] each

srun script.py -index "${SLURM_ARRAY_TASK_ID}" -f input.file
