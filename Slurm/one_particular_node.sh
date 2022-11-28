#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --cpus-per-task=16          # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --nodes=1                   # -N (exclusive way)
# SBATCH --exclusive                 # exclusive mode
#SBATCH --nodelist=c8220node[41-56,169-176]     # a particular set of nodes
# SBATCH --nodelist=c6420node[049-060]
# SBATCH --nodelist=r740bigmem201

# Be aware: doing such request may impact your priority (good or bad)

env > env-E5.txt

ls /scratch/ssd/


