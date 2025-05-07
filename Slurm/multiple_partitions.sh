#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short,Lake
#SBATCH --cpus-per-task=1           # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

env > env-"${SLURM_JOB_PARTITION}".txt

