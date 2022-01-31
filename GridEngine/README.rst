===========================
PSMN SGE submission scripts
===========================

TL;DR: bunch of submission scripts, some simple, some over-complicated, used in `PSMN <http://www.ens-lyon.fr/PSMN/>`_ at ENS de Lyon.

`PSMN <http://www.ens-lyon.fr/PSMN/>`_ is "Pôle Scientifique de Modélisation Numérique", the Computing Center and "MesoCentre" of `École Normale Supérieure de Lyon <http://www.ens-lyon.fr/en/>`_.

.. meta::
	:date: 2020-04-15
	:status: documentation
	:version: $Id: README.rst 1.10 $
	:licence: SPDX-License-Identifier: BSD-2-Clause

Tested with ``Sun Grid Engine v6.2u5`` and ``Son of Grid Engine v8.1.9``.


Documentation
=============

All scripts refer to `PSMN's documentation <http://www.ens-lyon.fr/PSMN/doku.php?id=documentation:accueil>`_ which will always be ahead of this repository.

``qstat -g c`` on any front server will give an actual queue list.


Snippets of options (bash scripts)
==================================


Use scratch, simple way:

.. code-block:: bash

    ### Our scratch tree is... complicated
    SCRATCH="/scratch/E5N"
    ### subsitute $HOME by $SCRATCH in $SGE_O_WORKDIR path
    SCRATCHDIR=${SGE_O_WORKDIR/"${HOME}"/"${SCRATCH}"}
    # then cp, cd, etc.


Variant, test and create:

.. code-block:: bash

    ### creation + verification global scratch
    if [[ -d "/scratch" ]]
    then
        ### for E5N scratch / E5 cluster
        if [[ -e "/scratch/E5N/E5N-gfs-scratch" ]]
        then
            SCRATCH="/scratch/E5N"
            SCRATCHDIR=${SGE_O_WORKDIR/"${HOME}"/"${SCRATCH}"}
            mkdir -p "${SCRATCHDIR}"
        else
            echo "/scratch not found, cannot create ${SCRATCHDIR}"
            exit 1
        fi
    else
        echo "/scratch not found, cannot create ${SCRATCHDIR}"
        exit 1
    fi
    # then cp, cd, etc.

Another variant, more scratchs, based on ``$JOB_ID``:

.. code-block:: bash

    ## for Chimie users (Lake cluster)
    if [[ -d "/scratch/Chimie" ]]
    then
        SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"

    # default on Lake cluster
    elif [[ -d "/scratch/Lake" ]]
    then
        SCRATCHDIR="/scratch/Lake/${USER}/${JOB_ID}/"

    # default on E5 cluster
    elif [[ -d "/scratch/E5N" ]]
    then
        SCRATCHDIR="/scratch/E5N/${USER}/${JOB_ID}/"

    # default to SGE_O_WORKDIR
    else
        echo "/scratch not found, cannot create ${SCRATCHDIR}"
        SCRATCHDIR="${SGE_O_WORKDIR}"
    fi
    # then cp, cd, etc.


