#!/bin/bash

# Specify the text file to read from
text_file="instruction_mem.mem"

stty -F /dev/ttyUSB1 115200
stty -F /dev/ttyUSB1 -crtscts

# Loop through each line in the text file
while IFS= read -r line
do
    hex=$(echo "obase=16;ibase=2;$line" | bc)

    if [ ${#hex} -lt 2 ]; then
        hex="0$hex"
    fi

    # Write the line to /dev/ttyUSB1
    # echo -n "$line" > /dev/ttyUSB1
    # echo -n "$line"
    # echo -n "$hex" >/dev/ttyUSB1 
    echo -n "\x$hex" >/dev/ttyUSB1 
    # echo -n "\x$hex" 
    # echo -n "$(echo -n "$line" | xxd -r -p)" > /dev/ttyUSB1
    #echo -n "$(echo -n "$line" | xxd -r -p)"
    #printf "%b" "$(echo -n "$line" | xxd -r -p)" > /dev/ttyUSB1
done < "$text_file"