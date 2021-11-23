=============================
PSMN Slurm submission scripts
=============================

TL;DR: bunch of submission scripts, some simple, some over-complicated, used in `PSMN <http://www.ens-lyon.fr/PSMN/>`_ at ENS de Lyon.

`PSMN <http://www.ens-lyon.fr/PSMN/>`_ is "Pôle Scientifique de Modélisation Numérique", the Computing Center and "MesoCentre" of `École Normale Supérieure de Lyon <http://www.ens-lyon.fr/en/>`_.


:date: 2021-10-29
:status: documentation
:version: $Id: README.rst 1.10 $
:licence: SPDX-License-Identifier: BSD-2-Clause

Using ``slurm-wlm 20.11.4``.


Documentation
=============

All scripts refer to `PSMN's documentation <http://www.ens-lyon.fr/PSMN/doku.php?id=documentation:accueil>`_ which will always be ahead of this repository.

``sinfo -l`` or ``sinfo -lNe`` on any front server will give an actual partition status.


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
    #SBATCH --time=0-00:10:00           # day-hours:minutes:seconds
    
    echo $ENV >> env.test

Asking for 1 core, 10 minutes, on partiton E5.


**TODO**
