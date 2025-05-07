#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=Lake-short
#SBATCH --nodes=2
#SBATCH --exclusive
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds

echo "${SLURM_SUBMIT_DIR}"

SCRATCHDIR="/scratch/Lake/${SLURM_JOB_USER}/${SLURM_JOB_ID}"

mkdir -p "${SCRATCHDIR}"

# See https://slurm.schedmd.com/mpi_guide.html
# there is multiples ways of using multiples MPI
# added some usefull (sometime) options

# example 0, OpenMPI 1.8+ (you should'nt use that one anymore)
# mpirun -np "${SLURM_NTASKS}" -mca btl sm,openib,self ./mybin < input > "${SCRATCHDIR}/output"

# example 1, OpenMPI 2 and 3
# mpirun -np "${SLURM_NTASKS}" -mca btl vader,openib,self ./mybin < input > "${SCRATCHDIR}/output"

# example 2, OpenMPI 4 (base debian or PSMN modules)
mpirun -np "${SLURM_NTASKS}" ./mybin < input > "${SCRATCHDIR}/output"

# example 3, Intel MPI
# proper PSMN's $USER/.ssh/config is MANDATORY
mpiexec -n "${SLURM_NPROCS}" -bootstrap ssh ./mybin -restart="${SLURM_SUBMIT_DIR}/input" -scratch="${SCRATCHDIR}"

# don't forget to cleanup/erase "${SCRATCHDIR}" after successfull run
