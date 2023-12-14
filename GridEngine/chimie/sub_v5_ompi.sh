#!/bin/bash
#$ -S /bin/bash
#$ -N vasp_ompi_8
#$ -q E5-2667v2*
#$ -pe mpi8_debian 8
#$ -V
#$ -cwd

# Choose the version of vasp by loading the module file accordingly
module use /home/tjiang/modules/lmod/

#choose a version of vasp by uncommenting the corresponding section below

# vasp 5.4.1
module load vasp/5.4.1_ompi1.8.8_intel15.0.2

#For vasp 5.4.4, we need to source the intel mpi mpivars script to properly set environment
#module load vasp/5.4.4_intel_suite2019.5
#source /applis/PSMN/debian9/software/Compiler/intel/2019.5/impi/2019.5.281/intel64/bin/mpivars.sh

#For vasp 6.2.0, we need to source the intel mpi mpivars script to properly set environment
#module load vasp/6.2.0_intel_suite2019.5
#source /applis/PSMN/debian9/software/Compiler/intel/2019.5/impi/2019.5.281/intel64/bin/mpivars.sh


# for OpenMP + multithreaded MKL
export OMP_NUM_THREADS="1"
export MKL_NUM_THREADS="1"
#ulimit -l unlimited

# Where are we
HOMEDIR="${SGE_O_WORKDIR}"

# stuff for parallel computing
HOSTFILE="${TMPDIR}/machines"

# save nodelist (optional)
#/bin/cat "${TMPDIR}/machines" > "${HOMEDIR}/tmp"

# Check which scratch to use
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
#SCRATCHDIR="/tmp/${USER}/${JOB_ID}/"
mkdir -p "${SCRATCHDIR}"
echo "scratch directory is: ${SCRATCHDIR}"


cd "${HOMEDIR}" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }
#Creating POTCAR, contribution of Stephan
rm POTCAR ; for i in `awk '{if(NR==6){print $0}}' POSCAR`  ; do cat ~tjiang/vasp/PSEUDOS_DATABASIS/2013/gw/potpaw/pbe/$i/POTCAR >> POTCAR ; done:w


#for normal calculation
/bin/cp -f INCAR KPOINTS POTCAR POSCAR WAVECAR "${SCRATCHDIR}/"
#for neb calculation, numbering depends on the number of images
#/bin/cp -rf INCAR KPOINTS POTCAR POSCAR WAVECAR 00 01 02 "${SCRATCHDIR}/"
# If starting wavecar and chgcar exists, uncomment the following line
#/bin/cp -f -- "${HOMEDIR}/CHG*" "${HOMEDIR}/WAVECAR" "${SCRATCHDIR}/"

# go to scratch (instead of SGE workdir)
cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}"; exit 1; }
echo "${HOMEDIR}" > homedir

# The line for computing
mpirun  -hostfile "${HOSTFILE}" -np "${NSLOTS}" vasp_std > "${HOMEDIR}/out"
#mpirun  -hostfile "${HOSTFILE}" -np "${NSLOTS}" vasp_gam > "${HOMEDIR}/out"
#mpirun  -hostfile "${HOSTFILE}" -np "${NSLOTS}" vasp_ncl > "${HOMEDIR}/out"

# Get back the results
# Full copy back
#cp -- WAVECAR CHG* OUTCAR POSCAR OSZICAR XDATCAR CONTCAR vasprun.xml "${HOMEDIR}/"
# Minimum copy back

bzip2 OUTCAR
#gzip OUTCAR
cp -rf OUTCAR.bz2 POSCAR OSZICAR XDATCAR CONTCAR "${HOMEDIR}/"
# copy back for neb calculation, numbering depends on the number of images
#cp -rf OUTCAR POSCAR OSZICAR XDATCAR CONTCAR 00 01 02 "${HOMEDIR}/"
# Zip OUTCAR to save space
cd "${HOMEDIR}/" || { echo "cannot cd to ${HOMEDIR}"; exit 1; }

# Cleaning up
# there should be a test here, what if ${SCRATCHDIR} = ${SGE_O_WORKDIR}?
rm -rf "${SCRATCHDIR}"

# The following part is only useful for users from the chemistry lab of ens-lyon.
# Importing finished calculation into database
#if [ ! -d "/home/${USER}/.chimie_db/" ]; then
#    mkdir "/home/${USER}/.chimie_db/"
#fi
#export PYTHONPATH="/home/tjiang/usr/lib/python2.7/site-package/:$PYTHONPATH"
#export PATH="/home/tjiang/chimie4psmn/database/:$PATH"
#import_vasp_calc -p -u "${USER}" -n 1 -d "/home/${USER}/.chimie_db/${USER}.db" "${HOMEDIR}"
