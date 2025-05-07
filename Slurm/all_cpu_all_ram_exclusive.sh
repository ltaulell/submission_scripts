#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --cpus-per-task=16
#SBATCH --ntasks=1
#SBATCH --exclusive                 # exclusive mode
#SBATCH --nodes=1                   # eq: I want this node for myself alone
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

env > env-Lake-short.txt

