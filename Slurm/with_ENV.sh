#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=1           # one CPU
#SBATCH --ntasks=1
#SBATCH --mem=2G                    # 2GiB mem overall
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --export=ALL                # export all $ENV variables to compute node

env > env-"${$SLURMD_NODENAME}".txt

