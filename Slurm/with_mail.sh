#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#
#SBATCH --mail-type=BEGIN,END,FAIL
# please *NEVER* use the 'ALL' flag, as it will overload mail servers
#SBATCH --mail-user=user@example.com

env > env-Lake-short.txt

