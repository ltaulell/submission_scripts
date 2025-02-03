#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

cd $SLURM_SUBMIT_DIR
mpirun -np $SLURM_NPROCS mybin < input > output

# Cores repartition depends on binary cores handling, and can be very tricky.
# You can have (ntasks-per-node x cpus-per-task)= $SLURM_NPROCS from different
# combinations: 2n x 16t x 1c = 32c OR 2n x 1t x 16c = 32c
# Best is to do some tests :)
