#!/bin/bash
#
#SBATCH --job-name=pseudo_para
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=1024              # not mandatory
#SBATCH --nodes=1
#SBATCH --exclusive                     # not mandatory
# SBATCH --ntasks-per-node=4            # choose this or --ntasks

# define some environment (test)
# shellcheck disable=SC1091
source /usr/share/lmod/lmod/init/bash

ml use /applis/PSMN/debian11/Lake/modules/all/
ml load GCC/11.2.0

# gather some env info (test)
env > env-"${SLURM_JOB_PARTITION}".txt

# my binary
BIN="stressapptest"

# where am I running
echo "${SLURM_NODELIST}"

# distribute sequential tasks as concurrent jobs one the same compute node
for i in $(seq "$SLURM_NTASKS");  # related to SBATCH --ntasks=4
# for i in $(seq "$SLURM_NTASKS_PER_NODE");  # related to SBATCH --ntasks-per-node=4
do
    RAM=$(("${i}" * 100))
    param="-C 1 -m 1 -i 1 -M ${RAM} -s 120"
    echo "$i : ${BIN} ${param}"

    # shellcheck disable=SC2086
    srun --exclusive --ntasks 1 ${BIN} ${param} &
    # srun --exclusive means independent tasks, either, it's serial
done

wait # tell bash/slurm to wait for all sub-tasks (srun) to finish before exit
