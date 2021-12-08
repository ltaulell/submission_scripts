#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=1           # -n
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

echo "${ENV}" > env-E5.txt

