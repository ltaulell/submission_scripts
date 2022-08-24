#!/usr/bin/env python3
# coding: utf-8
#
# slurm parameters
#SBATCH --job-name=seq_param_test
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=8                      # SLURM_NTASKS
#SBATCH --nodes=1
#SBATCH --exclusive
# SBATCH --ntasks-per-node=8            # SLURM_NTASKS_PER_NODE

# actual compute script
""" parametric exploration, with a sequential binary """

import os
import sys
import time

time.sleep(1)  # let os.ENV initialize properly

if os.environ.get('SLURM_NTASKS'):
    tasks = int(os.environ.get('SLURM_NTASKS'))
else:
    sys.exit(f'incorrect job initilization')

N_samples = 1

for i in range(tasks):
    seed = 1 + i * N_samples
    command = f'echo "running -s {seed} -n {N_samples} -t 2000" ; sleep 180'

    print(f"{command}")
    os.system("srun --ntasks 1 {} &".format(command))

