#!/usr/bin/env python3
# coding: utf-8

# $Id: multiple_openmp_with_parametric.py 2879 $
# SPDX-License-Identifier: BSD-2-Clause

""" submit a bunch of OpenMP jobs, with parametric file for each one, to SGE 

    It is a commented example from a production code. Modify at will.

"""

__author__ = 'ltaulell'
__credits__ = 'Pratyush Pranav <pratyuze AT gmail.com>'

import os
import sys

# computation parameters
mask = [0.9, 0.95]
degrade = [2048, 1024]
BEGIN = 100
END = 1001  # not included, python3 range is [begin, end[

# inputs & outputs
email = 'login@example.com'  # optionnal, prefer @ens-lyon address
binary1 = './create_fits_degrade'  # full path or './' to binary
binary2 = '/path/to/another/binary/polyhedron_superset'  # full path or './' to binary
binary3 = ''  # full path or './' to binary
scratch = '/scratch/E5N/ltaulell/projet/'  # with final '/'
outdir = scratch + 'output/'  # with final '/'


def write_file(filename, filecontent):
    """ write filecontent into filename, obviously """
    verify_or_create_dir(filename)
    try:
        with open(filename, 'w') as f:
            f.write(filecontent)
    except EnvironmentError as err:
        print('cannot write: {}, {}'.format(filename, err))


def verify_or_create_dir(filename):
    """ Verify if path exist (before a file will be created/written)
        create path if it doesn't exist
    """
    if not os.path.exists(os.path.dirname(filename)):
        try:
            os.makedirs(os.path.dirname(filename), exist_ok=True)
        except OSError as err:
            print('Cannot create directory: {}'.format(err))
            sys.exit(1)


for d in degrade:
    for i in range(BEGIN, END):

        param_file = '\n'.join([
            # example is built as a .ini file
            'sides=' + str(d),
            'infile=cube3_nlc_int_' + str(i).zfill(5) + '_' + str(d) + '.fits',
            'maskfile=' + scratch + 'common_masks/' + str(d) + '_R2.01.mask',
            'outfile=degrade_' + str(d) + '/cube3_nlc_int_' + str(i) + '.out',
            'level=0.9',
            'polarisation=false',
            'pessimistic=false',
            'adjuvent=true',
            ''])  # EOF
        # print(param_file)  # debug purpose

        param_file_name = ''.join(['degrade_', str(d), '/params', str(d), '_', str(i), '.txt'])
        # print(param_file_name)  # debug purpose
        write_file(param_file_name, param_file)

        sge_script = '\n'.join([
            # same as a common SGE shell file
            '#!/bin/bash',
            '#$ -S /bin/bash',
            '# use submission environment',
            '#$ -cwd',
            '#$ -V',
            # ${JOB_NAME}
            '#$ -N job' + str(d) + '_' + str(i),
            # WARNING: One queue line at a time
            '#$ -q h48-E5-2670deb128,h6-E5-2667v4deb128',  # E5 cluster -> E5N scratch
            # '#$ -q CLG5218deb192*',  # Lake cluster -> Lake scratch
            #
            # WARNING: core count MUST match queue's
            # See documentation on PSMN website
            '#$ -pe openmp32 32',
            #
            # SGE outputs will be in "${SGE_O_WORKDIR}"/"${JOB_NAME}".[e,o,pe,po]"${JOB_ID}" by default
            '#$ -e ' + outdir + 'degrade_' + str(d) + '/e_' + str(i),
            '#$ -o ' + outdir + 'degrade_' + str(d) + '/o_' + str(i),
            '#$ -m a',
            '#$ -M ' + email,
            '# start job from the directory it was submitted',
            'cd "${SGE_O_WORKDIR}"',
            # Add $ENV preparation, if needed:
            # 'source ~/.bashrc',
            # 'module load Python/3.6.1',
            # 'cd /another/path/newdata',
            # Finally, your program(s)
            binary1 + ' < ' + param_file_name + ' | ' + binary2 + ' > ' + outdir,
            ''])  # end of submit script

        # print(sge_script)  # debug purpose

        script_file_name = ''.join(['./', 'job_d', str(d), '_', str(i), '.sh'])  # full path or './'
        # print(script_file_name)  # debug purpose
        write_file(script_file_name, sge_script)

        toRun = '{} {}'.format('qsub', script_file_name)
        print(toRun)  # debug purpose
        #os.system(toRun)  # uncomment for production
