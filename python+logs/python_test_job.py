#!/usr/bin/env python3
# coding: utf-8
#
# $Id: python_test_job.py 1499 $
# SPDX-License-Identifier: BSD-2-Clause

"""
test python logging in SGE context: SGE will log, no matter what.

print() -> STDOUT -> SGE.stdout -> ${JOB_NAME}.o${JOB_ID}

SGE will catch everything else via STDERR, so :
log.[critical-debug] -> file.log + SGE.stderr -> ${JOB_NAME}.e${JOB_ID}

https://stackoverflow.com/questions/31599940/how-to-print-current-logging-configuration-used-by-the-python-logging-module

"""

import os
import sys
import argparse
import logging
from logging.handlers import RotatingFileHandler

LOG_LEVELS = ['critical', 'error', 'warning', 'info', 'debug']

# define general/default logging
logs = logging.getLogger(__name__)
logs.setLevel(logging.ERROR)
#stream_handler = logging.StreamHandler()
#logs.addHandler(stream_handler)


def get_args(helper=False):
    """ read parser and return args (as args namespace),
        if helper=True, show usage() or help()
    """
    parser = argparse.ArgumentParser(description='Do nothing, but log it')
    parser.add_argument('-d', '--debug', action='store_true', help='toggle debug ON')

    if helper:
        return parser.print_usage()
        # return parser.print_help()
    else:
        return parser.parse_args()


def init_logs(debug=False):
    """ init logs:
    apply a format
    set RotatingFileHandler -> log to a file
    set stream_handler -> STDOUT (should already be default)
    """

    formatter = logging.Formatter(
        '%(asctime)s :: %(levelname)s :: %(message)s')

    # on peut aussi utiliser basicConfig
    # logging.basicConfig(
    #    filename = 'test_log.log',
    #    level = logging.INFO,
    #    format = '[%(asctime)s] {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s',
    #    datefmt = '%H:%M:%S'
    # )

    if debug:
        logs.setLevel(logging.DEBUG)
        logs.debug(get_args(helper=True))
    else:
        logs.setLevel(logging.ERROR)

    # logger dans un fichier
    # nom du script sans son extension : os.path.splitext(sys.argv[0])[0]
    scriptname = os.path.splitext(sys.argv[0])[0]
    file_handler = RotatingFileHandler(scriptname + '.log', 'a', 1000000, 1)

    if debug:
        file_handler.setLevel(logging.DEBUG)
    else:
        file_handler.setLevel(logging.ERROR)

    file_handler.setFormatter(formatter)
    logs.addHandler(file_handler)

    # logger sur la console -> STDOUT
    # stream_handler = logging.StreamHandler()
    # if debug:
    #    stream_handler.setLevel(logging.INFO)
    #else:
    #    stream_handler.setLevel(logging.ERROR)
    # logs.addHandler(stream_handler)


if __name__ == '__main__':
    """ """

    args = get_args()

    init_logs(debug=args.debug)

    if args.debug:
        # -> STDOUT
        print('mode debug')
        # -> handler(s)
        logs.debug('handler: mode {}'.format(logging.getLevelName(logs.getEffectiveLevel())))

    for level in LOG_LEVELS:
        logs.info(level)
