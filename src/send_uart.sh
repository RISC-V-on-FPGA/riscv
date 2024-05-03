#!/bin/bash

# Make sure the assembly code is moved to instruction_mem.mem
python3 ripes_to_bytes.py

# Specify the text file to read from
text_file="instruction_mem.mem"

stty -F /dev/ttyUSB1 115200
stty -F /dev/ttyUSB1 -crtscts

# Loop through each line in the text file
while IFS= read -r line
do
    hex=$(echo "obase=16;ibase=2;$line" | bc)

    # Write the line to /dev/ttyUSB1
    echo -n "\x$hex" >/dev/ttyUSB1 

done < "$text_file"