#!/usr/bin/env python3
# coding: utf-8
#
# slurm parameters
#SBATCH --job-name=pytest
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=8            # Lake has 32 cores/node
#SBATCH --nodes=1
#SBATCH --exclusive           # exclusive mode, ie: this node will be mine

# actual script

import os
import sys
import time

time.sleep(2)  # let os.ENV initialize properly

SLURM_ENV = ["SLURM_JOB_ID", "SLURM_NTASKS", "SLURM_NPROCS", "SLURM_SUBMIT_HOST", "SLURM_STEP_TASKS_PER_NODE", "SLURM_CPUS_ON_NODE", "SLURM_JOB_CPUS_PER_NODE"]

for elt in SLURM_ENV:
    print(f"{elt}:", os.environ.get(elt))

