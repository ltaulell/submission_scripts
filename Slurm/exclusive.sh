#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --cpus-per-task=1           # -n
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --nodes=2                   # -N (2 nodes, exclusive way)
#SBATCH --exclusive                 # exclusive mode, ie: all 2 nodes will be mine

# Be aware: this script is *DUMB*, it will reserve 2 nodes, and only one will be used
# **this is a waste of resources**

env > env-Lake-short.txt

