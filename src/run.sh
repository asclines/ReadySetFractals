#!/bin/bash

OPTIONS="-f 2 -d 512"

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

