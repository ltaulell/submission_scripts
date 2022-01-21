#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=1           # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --mem-per-cpu=500           # in MiB
#SBATCH --mem=500                   # global to node, in MiB
# SBATCH --mem=2G                   # global to node, in GiB, ignored

echo "${ENV}" > env-E5.txt

