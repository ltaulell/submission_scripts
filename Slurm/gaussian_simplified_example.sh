#!/bin/bash
#SBATCH --job-name=gaussian_test
#SBATCH --partition=Lake
#SBATCH --cpus-per-task=32
#SBATCH --mem=180G                  # global to node, in GiB
#SBATCH --ntasks=1
#SBATCH --exclusive                 # exclusive mode
#SBATCH --nodes=1                   # eq: I want this node for myself alone
#SBATCH --time=7-23:50:00           # day-hours:minutes:seconds

# set globals
g09root="/applis/PSMN/generic/gaussian/g09d01"
job="structure11"
ExtIn="com"
ExtOut="log"

source "$g09root/g09/bsd/g09.profile"
export Gaussian="$g09root/g09/g09"

HOMEDIR="${SLURM_SUBMIT_DIR}"

# running on Lake partition, scratch is "/scratch/Chimie"
SCRATCHDIR="/scratch/Chimie/${USER}/${SLURM_JOB_ID}/"
mkdir -p "${SCRATCHDIR}"
export GAUSS_SCRDIR="${SCRATCHDIR}"

# copy input
cp "${HOMEDIR}/${job}.${ExtIn}" "${SCRATCHDIR}"

# copy chk
NChk=$(grep -i "chk" ${job}.${ExtIn} | awk -F"=" '{print $2}')
if [[ -e "$NChk" ]]
then
    cp "${HOMEDIR}/${NChk}" "${SCRATCHDIR}"
else
    echo "no CHK, starting fresh"
fi

# go to scratchdir
cd "${SCRATCHDIR}" || { echo "cannot cd to ${SCRATCHDIR}" ; exit 1; }

# run program
#/usr/bin/time ${Gaussian} < ${job}.${ExtIn} > ${HOMEDIR}/${job}.${ExtOut}  # debug
"${Gaussian}" < "${job}.${ExtIn}" > "${HOMEDIR}/${job}.${ExtOut}"

# save chk
if [[ -s "$NChk" ]]
then
    gzip -9 "$NChk"
    cp "${SCRATCHDIR}/${NChk}.gz" "${HOMEDIR}/"
fi

# final cleanup (commented during debug)
rm -rf "${GAUSS_SCRDIR}"
