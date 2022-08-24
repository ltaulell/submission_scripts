#!/bin/bash
#
#SBATCH --job-name=pseudo_para
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=4
#SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
# SBATCH --nodes=1
# SBATCH --exclusive

source /usr/share/lmod/lmod/init/bash
ml use /applis/PSMN/debian11/Lake/modules/all/
ml load GCC/11.2.0

env > env-"${SLURM_JOB_PARTITION}".txt

BIN="stressapptest"

echo "${SLURM_NODELIST}"

for i in $(seq "$SLURM_NTASKS");
do
    param="-C 1 -m 1 -i 1 -M 100 -s 120"
    echo "$i : ${BIN} ${param}"
    srun --ntasks 1 ${BIN} ${param} &
    # ${BIN} ${param} &
done

wait
