=============================
PSMN Slurm submission scripts
=============================

TL;DR: bunch of submission scripts, some simple, some over-complicated, used in `PSMN <http://www.ens-lyon.fr/PSMN/>`_ at ENS de Lyon.

`PSMN <http://www.ens-lyon.fr/PSMN/>`_ is "Pôle Scientifique de Modélisation Numérique", the Computing Center and "MesoCentre" of `École Normale Supérieure de Lyon <http://www.ens-lyon.fr/en/>`_.

.. meta::
	:date: 2021-10-29
	:status: documentation
	:version: $Id: README.rst 1.13 $
	:licence: SPDX-License-Identifier: BSD-2-Clause

Using ``slurm-wlm 20.11.4``.


Documentation
=============

All scripts refer to `PSMN's documentation <http://www.ens-lyon.fr/PSMN/doku.php?id=documentation:accueil>`_ which will always be ahead of this repository.

``sinfo -l`` or ``sinfo -lNe`` on any front server will give an **actual partition status and names**.


Snippets of options (bash scripts)
==================================

Submit using ``sbatch test.sh``.


Simpliest script
----------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=test

    python3 my_prog.py


Within default partition, default duration and python3 from system defaults.

Simplest script
---------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=test
    #SBATCH --partition=E5
    #SBATCH --cpus-per-task=1           # -n
    #SBATCH --mem-per-cpu=500           # in MiB
    #SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
    
    env > env.test

Asking for 1 core, 500MiB, 10 minutes, on partition E5, shared node.


One core, one node exclusive
----------------------------

hence, all available RAM (of the node).

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=test
    #SBATCH --partition=E5
    #SBATCH --cpus-per-task=1           # -n
    #SBATCH --ntasks=1
    #SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
    #SBATCH --nodes=1                   # -N (number of node(s))
    #SBATCH --exclusive                 # exclusive mode
    
    myappli < input > output


Asking for 1 core, 10 minutes, E5 partition, 1 node exclusive.


Environment Slurm variables
---------------------------

There's a bunch of available slurm variables, within your job environment:

+--------------------------+-------------------------------------------------------+
| slurm variable           | whatis                                                |
+==========================+=======================================================+
| $SLURM_JOB_ID            | ID given by slurmctl                                  |
+--------------------------+-------------------------------------------------------+
| $SLURM_JOB_NAME          | sbatch --job-name                                     |
+--------------------------+-------------------------------------------------------+
| $SLURM_JOB_USER          | $USER                                                 |
+--------------------------+-------------------------------------------------------+
| $SLURM_SUBMIT_DIR        | where you submitted from                              |
+--------------------------+-------------------------------------------------------+
| $SLURM_NODELIST          | node(s) list allocated to job                         |
+--------------------------+-------------------------------------------------------+
| $SLURMD_NODENAME         | node running the job                                  |
+--------------------------+-------------------------------------------------------+
| $SLURM_NPROCS            | number of core(s) of job                              |
+--------------------------+-------------------------------------------------------+
| $SLURM_NTASKS            | Maximum number of MPI tasks                           |
+--------------------------+-------------------------------------------------------+
| $SLURM_NTASKS_PER_NODE   | Number of tasks requested per node                    |
+--------------------------+-------------------------------------------------------+
| $SLURM_CPUS_ON_NODE      | Number of CPUs on the allocated node                  |
+--------------------------+-------------------------------------------------------+
| $SLURM_JOB_CPUS_PER_NODE | Count of processors available to the job on this node |
+--------------------------+-------------------------------------------------------+
| $SLURM_JOB_PARTITION     | partition name                                        |
+--------------------------+-------------------------------------------------------+



