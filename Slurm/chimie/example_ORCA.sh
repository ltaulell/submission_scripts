#!/bin/bash
#SBATCH --job-name=orca_job
#SBATCH -o ./%x.%j.%N.out           # output file
#SBATCH -e ./%x.%j.%N.err           # errors file
#
#SBATCH -p Lake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --time=00-10:00:00           # day-hours:minutes:seconds
#SBATCH --mem-per-cpu=4G

echo "The job ${SLURM_JOB_ID} is running on these nodes:"
echo ${SLURM_NODELIST}
echo


module purge
module use /applis/PSMN/debian13/Lake/modules/all
module load ORCA/6.1.0-gompi-2023b-avx2

/applis/PSMN/debian13/Lake/software/ORCA/6.1.0-gompi-2023b-avx2/bin/orca fichier.inp > fichier.out 

