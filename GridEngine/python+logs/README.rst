=============================
Python3 + SGE logging example
=============================

Small test to handle python3 logging in SGE context: SGE will log, no matter what.

every print() instruction will be catch via SGE own STDOUT handler:

``print() -> STDOUT -> SGE.stdout -> ${JOB_NAME}.o${JOB_ID}``

Everything else will be catch via STDERR SGE handler:

``log.([critical-debug]) -> file.log AND SGE.stderr -> ${JOB_NAME}.e${JOB_ID}``

Please play with the provided example.

