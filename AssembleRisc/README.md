# AssembleRisc
A Python assembler for RISC-V


## How to run
First, `cd` to the `src` directory. By default, the assembler takes the `examples\tryouts.s` as input and can be invoked like:

    $ python main.py

If you want to use another file as input, then you can run the `main.py` file with your input assembly file (here assumed to be named `my_asm.s` and in the same `src` directory):

    $ python main.py -i my_asm.s

The output files, both in textual binary and hexadeciaml, are placed in the `output` directory.
