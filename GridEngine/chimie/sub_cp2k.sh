#!/bin/bash
#$ -S /bin/bash
#$ -N cp2kjob          # The name of the job can be changed here
#$ -q E5-2667v4deb256A
#$ -pe mpi16_debian 16
#$ -V
#$ -cwd

module purge
module use /home/tjiang/modules/lmod
#choose different versions of cp2k
#5.1
module load cp2k/5.1_gcc7.2_avx_pclabaut
#7.1
#module load cp2k/7.1_gcc7.2_avx2
#source /Xnfs/chimie/cp2k/7.1/gcc7.2_avx2/tools/toolchain/install/setup

cat $TMPDIR/machines
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

cp md.inp "${SCRATCHDIR}"
cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }
mpirun -x LIBRARY_PATH -x CPATH -x LD_LIBRARY_PATH -hostfile $TMPDIR/machines -np $NSLOTS cp2k.popt -i md.inp > md.out

#Please change the outputfiles_only to the output files you need to copy back
cp -- outputfiles_only "${SGE_O_WORKDIR}"
rm -rf "${SCRATCHDIR}"
