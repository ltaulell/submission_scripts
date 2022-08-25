#!/bin/bash
#
#SBATCH --job-name=pseudo_para
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --exclusive

# shellcheck disable=SC1091
source /usr/share/lmod/lmod/init/bash

ml use /applis/PSMN/debian11/Lake/modules/all/
ml load GCC/11.2.0

env > env-"${SLURM_JOB_PARTITION}".txt

BIN="stressapptest"

echo "${SLURM_NODELIST}"

for i in $(seq "$SLURM_NTASKS");
do
    RAM=$(("${i}" * 100))
    param="-C 1 -m 1 -i 1 -M ${RAM} -s 120"
    echo "$i : ${BIN} ${param}"

    # shellcheck disable=SC2086
    srun --ntasks 1 ${BIN} ${param} &
done

wait # tell bash to wait for all sub-tasks (srun) to finish before exit
