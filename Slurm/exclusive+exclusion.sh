#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=16          # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --nodes=1                   # -N (exclusive way)
#SBATCH --exclusive                 # exclusive mode
#SBATCH --exclude=c82gluster1       # nobody like gluster1, he compute backward

echo "${ENV}" > env-E5.txt

