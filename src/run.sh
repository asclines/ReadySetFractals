#!/bin/bash

OPTIONS="-f 2 -d 1024 -e 2 -m 100 -r 1.5 -x -.5 -y 0 -c -50 -I .26 -R .4"

echo Cleaving up files from previous run
rm run_log.txt &>/dev/null
rm output_image.bmp  &> run_log.txt
rm out.txt &>run_log.txt
#rm program &>run_log.txt
echo Making file
make all &>run_log.txt
echo Starting program
getopts ":s" opt;
        if [ "$opt" == "s" ] ; then
                echo "Running with srun"
                time srun ./program
        else
                echo "Running normally"
                time ./program $OPTIONS
        fi
echo Loading image
eog output_image.bmp&

