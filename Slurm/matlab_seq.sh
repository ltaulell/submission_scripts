#!/bin/bash
#SBATCH --job-name=test_matlab
#SBATCH --partition=Lake-short
#SBATCH --cpus-per-task=1           # -n
#SBATCH --mem-per-cpu=500           # in MiB
#SBATCH --ntasks=1
#SBATCH --time=0-0:30:00            # day-hours:minutes:seconds

module use /applis/PSMN/debian11/Generic/modules/all/
module load Matlab/R2019b

matlab -nodisplay -nodesktop -nojvm -nosplash script.m
