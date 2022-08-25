#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=E5
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8          # half a node, on E5
#SBATCH --mem-per-cpu=1024         # in MiB, so 8GiB (8c x 1GiB)
#SBATCH --time=0-10:00:00          # day-hours:minutes:seconds, 10 hours

python3 my_prog.py
