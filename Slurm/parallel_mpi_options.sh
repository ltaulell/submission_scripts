#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

echo "${SLURM_SUBMIT_DIR}"

SCRATCHDIR="/scratch/E5N/${SLURM_JOB_USER}/${SLURM_JOB_ID}"

mkdir -p "${SCRATCHDIR}"

# See https://slurm.schedmd.com/mpi_guide.html
# multiples ways of using multiples MPI
# added some usefull options, sometimes

# example 1, OpenMPI
mpirun -np "${SLURM_NTASKS}" -mca btl vader,openib,self ./mybin < input > "${SCRATCHDIR}/output"

# example 2, Intel MPI
mpiexec -n "${SLURM_NPROCS}" -bootstrap ssh ./mybin -restart="${SLURM_SUBMIT_DIR}/input" -scratch="${SCRATCHDIR}"

# don't forget to cleanup/erase "${SCRATCHDIR}" after successfull run
