#!/bin/bash

filename=$1

output=$(iverilog -g2012 -o waveforms/$filename\_test $filename.sv simulation/$filename\_tb.sv 2>&1)
# vvp simulation/$filename\_test
# gtkwave waveform.vcd &

if [[ -z "$output" ]]; then
    vvp waveforms/$filename\_test
    output=$(gtkwave waveform.vcd waveforms/$filename\_tb.gtkw 2>&1)
    if [[ -z "$output" ]]; then
        gtkwave waveform.vcd
    fi
    #echo "$output"
else
    echo "Output from iverilog command:"
    echo "$output"
fi