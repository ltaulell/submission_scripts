#!/bin/bash
#$ -S /bin/bash
#$ -N test
#$ -o $JOB_NAME.batch-log
#$ -j y
#$ -cwd
#$ -V
#$ -q E5*
##$ -pe gaussian8 8
#$ -pe openmp8 8

# trace script (debug purpose, not mandatory)
#set -x
# set globals
job="structure11"
ExtIn="com"
ExtOut="log"

# Environment setting for gaussian
module use /home/tjiang/modules/lmod
# Automatically decide which binary to use, depending on the cpu architecture
cpu_arch="$(sed '20q;d' /proc/cpuinfo)"
module use /home/tjiang/modules/lmod
if  [[ $cpu_arch = *"avx2"* ]]; then
    module load gaussian/g16-avx2
elif  [[ $cpu_arch = *"avx"* ]]; then
    module load gaussian/g16-avx
else
    echo ""
    echo "#########################################################"
    echo "This queue (${QUEUE}) is too old for running Gaussian 16!!!"
    echo "#########################################################"
    echo ""
    exit
fi
source "$g16root/g16/bsd/g16.profile"
export Gaussian="$g16root/g16/g16"

#cd "${SGE_O_WORKDIR}" || { echo "cannot cd to ${SGE_O_WORKDIR}"; exit 1; }
#echo "########## begin env##################"
#env
#echo "########## end env ##################"
echo "########## Hostname ##################"
hostname

HOMEDIR="${SGE_O_WORKDIR}"
# Replace 'home' by 'scratch', from SGE_O_WORKDIR, store to SCRATCHDIR
# check if scratch exist, create or complain
if [[ -d "/scratch/Chimie" ]]
then
    SCRATCHDIR="/scratch/Chimie/${USER}/${JOB_ID}/"
    mkdir -p "${SCRATCHDIR}"
elif [[ -d "/scratch/Lake" ]]
then
    SCRATCHDIR=/scratch/Lake/${USER}/${JOB_ID}/
    mkdir -p "${SCRATCHDIR}"
elif [[ -d "/scratch/E5N" ]]
then
    SCRATCHDIR=/scratch/E5N/${USER}/${JOB_ID}/
    mkdir -p "${SCRATCHDIR}"
else
    echo "/scratch not found, cannot create ${SCRATCHDIR}"
    exit 1
fi

CalcDir="${SCRATCHDIR}"
echo "Creating scratch for this job: ${SCRATCHDIR}"
mkdir -p "${CalcDir}"


# Gaussian specific ScratchDir
export GAUSS_SCRDIR="${CalcDir}"

Machine=$(hostname)

# check if there is a chk or chk.gz
# TODO/FIXME there's a problem here, watching the trace: if no chk, it create a .chk.chk
NChk=$(grep -i "chk" ${job}.${ExtIn} | head -1 | sed 's/=/ /g' | awk '{print $2}')
if [ "$NChk" != "" ]
then
NChk=$(basename "$NChk" .chk).chk
fi
if [[ -s "${HOMEDIR}/${NChk}" ]]
then
    cp "${HOMEDIR}/${NChk}" "${CalcDir}/${NChk}"
fi
if [[ -s "${HOMEDIR}/${NChk}.gz" ]]
then
    cp "${HOMEDIR}/${NChk}.gz" "${CalcDir}/${NChk}.gz"
    gunzip "${CalcDir}/${NChk}.gz"
fi

cp "${HOMEDIR}/${job}.${ExtIn}" "${CalcDir}/"

# logrotate old logs
if [[ -s "${HOMEDIR}/${job}.${ExtOut}" ]]
then
    Ext=1
    while [[ -s "${HOMEDIR}/${job}.${ExtOut}_${Ext}" ]]
    do
        #let Ext=Ext+1
        Ext=$(( Ext+1 ))
    done
    mv "${HOMEDIR}/${job}.${ExtOut}" "${HOMEDIR}/${job}.${ExtOut}_${Ext}"
fi

cd "${CalcDir}" || { echo "cannot cd to ${CalcDir}"; exit 1; }
echo "${CalcDir}"
ls -al

#echo "time ${Gaussian} < ${job}.${ExtIn} > ${HOMEDIR}/${job}.${ExtOut}"

#/usr/bin/time ${Gaussian} < ${job}.${ExtIn} > ${HOMEDIR}/${job}.${ExtOut}
"${Gaussian}" < "${job}.${ExtIn}" > "${HOMEDIR}/${job}.${ExtOut}"

if [[ -s "${NChk}" ]]
then
    gzip -9 "${NChk}"
    cp "${NChk}.gz" "${HOMEDIR}/"
fi


#copy back everything including the huge rwf files, normally we don't need it
#cp -- * "${HOMEDIR}/"
cp -- outputfiles_only "${HOMEDIR}/"

# final cleanup (commented during debug)
rm -r "${GAUSS_SCRDIR}"
