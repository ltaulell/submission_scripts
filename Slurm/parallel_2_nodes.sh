#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

cd $SLURM_SUBMIT_DIR
mpirun -np $SLURM_NTASKS mybin < input > output

