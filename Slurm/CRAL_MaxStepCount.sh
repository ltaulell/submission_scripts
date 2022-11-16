#!/bin/bash
# CRAL, from tgarel, unige.ch
#SBATCH -J test-cdd
#SBATCH -p Cascade
#SBATCH -o %x.%j.out
#SBATCH -e %x.%j.err
#SBATCH --ntasks=100
#SBATCH --mem-per-cpu=1000M
#SBATCH --cpus-per-task=8
#SBATCH --time=03:30:00
## Adding --exclusive makes all steps to be launched on the same node,
## hence ntasks are run at exact same time.
## It may be slower though because it can wait for a full node to be available
##SBATCH --exclusive
#
echo "$SLURM_JOB_ID / $SLURM_JOB_NAME / $SLURM_JOB_USER"
echo "$SLURM_SUBMIT_DIR on $SLURM_NODELIST"
echo "--------"
#
cd $SLURM_SUBMIT_DIR
#
module purge
module use /applis/PSMN/debian11/Cascade/modules/all
module load OpenMPI/4.1.1-GCC-10.3.0

START_TIME=$SECONDS

for i in {1..68880}; do
    echo "JOB i = $i"
    ### Checks that the nb of jobs running =< nstasks
    while [ "$(jobs -p | wc -l)" -ge "$SLURM_NTASKS" ]; do
        #echo "$(jobs -p | wc -l)"
        #echo "Ntasks = $SLURM_NTASKS"
        #echo "i = $i"
      sleep 1
    done
    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    cmdline=$(head -n $i jobs/joblist_cdd.input | tail -n 1)
    read -a arrIN <<< "$cmdline"
    #arrIN contains the command line extract from the joblist:
    #arrIN[0]=executable, arrIN[1]=parameter file, (arrIN[2]=useless here), arrIN[3]=log file
    srun --ntasks=1 --exclusive -N 1 -c $SLURM_CPUS_PER_TASK ${arrIN[0]} ${arrIN[1]} &> ${arrIN[3]}  &
done
wait

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Elapsed time = $ELAPSED_TIME seconds"
