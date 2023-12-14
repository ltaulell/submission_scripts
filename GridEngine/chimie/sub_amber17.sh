#!/bin/bash
#$ -S /bin/bash
#$ -N amber17
#$ -cwd
#$ -V
#$ -o npt4.out
#$ -j y
##=====================
##Choose between cpu queues and gpu queues, default gpu queues
##cpu queues
##$ -q M6*,E5-2667*,E5-2697*,E5-2670deb*
##$ -pe mpi16_debian 16
##gpu queues
#$ -q E5-2670gpuK20deb128,r7x0deb128gpu
#$ -pe mpi_debian 1
##=====================

# LCH: $Id$
#

export MODULEPATH="/home/tjiang/modules/lmod/:${MODULEPATH}"
module use "${MODULEPATH}"

#module file for gpu version of amber
module load amber/17_gcc5.4.0_cuda8.0ga2_openmpi1.6.4

#module file for cpu only version of amber
#module load amber/17_intel15.0.2_openmpi1.6.4

ambermod=$(basename "${AMBERHOME}")
echo "${ambermod}"
if [ "${ambermod}" = "gcc5.4.0_cuda8.0ga2_openmpi1.6.4" ]; then
    amberexe="pmemd.cuda"
else
    amberexe="pmemd"
fi
echo "${amberexe}"

ulimit -v unlimited
ulimit -s unlimited

######################"
HOMEDIR="${SGE_O_WORKDIR}"
HOSTFILE="${TMPDIR}/machines"

cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }

echo NSLOTS="${NSLOTS}"

if [[ -d "/scratch/Chimie" ]]
then
    SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/Lake" ]]
then
    SCRATCHDIR="/scratch/Lake/${USER}/${JOB_ID}/"
elif [[ -d "/scratch/E5N" ]]
then
    SCRATCHDIR="/scratch/E5N/${USER}/${JOB_ID}/"
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi
# Using /tmp as scratch instead
# SCRATCHDIR="/tmp/${USER}/${JOB_ID}/"

echo "Creating scratch for this job: ${SCRATCHDIR}"
/bin/mkdir -p "${SCRATCHDIR}"
###################
Mac=$(hostname | awk '{print substr($1,1,2)}')

NbMac=$(wc "${PE_HOSTFILE}" | awk '{print $1}')
rm ./machines
for i in $(seq 1 "$NbMac")
    do
        Mac=$(head -n "$i" "${PE_HOSTFILE}" | tail -1 | awk '{print $1}')
        Nb=$(head -n "$i" "${PE_HOSTFILE}" | tail -1 | awk '{print $2}')
        for j in $(seq 1 "$Nb")  # SC2034: j appears unused. Verify use (or export if used externally).
             do
                 echo "$Mac" >> ./machines
                  done
                  done

                  cp "${PE_HOSTFILE}" ./PE_HOSTFILE

                  cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }

                  echo "start at"
                  date

                  echo -n "Starting Script at: "
                  date
                  "$amberexe" -O -i "$HOMEDIR/min.in" \
                                -o "$HOMEDIR/min.out" \
                                -p "$HOMEDIR/dna_TT.prmtop" \
                                -c "$HOMEDIR/dna3_TT.inpcrd" \
                                -r "$HOMEDIR/dna_TT_min.rst" \
                                -x "$HOMEDIR/dna_TT_min.mdcrd"

                  echo "done at"
                  date
                  cp -rf -- outputfiles_only "${HOMEDIR}"
                  rm -rf "${SCRATCHDIR}"
