#!/bin/bash
#SBATCH --job-name=test
#SBATCH --ntasks=1

# using default partition, with default duration, and default python3

python3 my_prog.py

