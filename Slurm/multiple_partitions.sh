#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5,Lake
#SBATCH --cpus-per-task=1           # -n
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

env > env-"${SLURM_JOB_PARTITION}".txt

