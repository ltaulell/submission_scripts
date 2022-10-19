#!/bin/bash
#SBATCH --job-name=test_matlab
#SBATCH --partition=E5
#SBATCH --cpus-per-task=16          # -n
#SBATCH --ntasks=1
#SBATCH --time=0-01:00:00           # day-hours:minutes:seconds
#SBATCH --nodes=1                   # -N
#SBATCH --exclusive                 # exclusive mode, ie: this node will be mine


module use /applis/PSMN/debian11/Generic/modules/all/
module load Matlab/R2019b

matlab -nodisplay -nodesktop -nojvm -nosplash script.m


