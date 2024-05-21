from assembler.assemblerisc import AssembleRisc
import argparse


def get_args() -> str:
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="Input assembly file name.")
    args = parser.parse_args()
    input_file = args.input if args.input else '../examples/tryouts.s'
    return input_file


def write_output_file(filename, content):
    with open(filename, 'w') as file:
        file.write(content)


def _convert_to_hex(binary_code) -> str:
    hex_result = ""
    codes = binary_code.splitlines()
    for code in codes:
        is_compressed = len(code) == 16
        if is_compressed:
            hex_result += '{0:04x}'.format(int(code, 2)) + "\n"
        else:
            hex_result += '{0:08x}'.format(int(code, 2)) + "\n"
    return hex_result


def main():
    input_filename = get_args()

    assembler = AssembleRisc()
    binary_code = assembler.assemble(input_filename)
    hex_code = _convert_to_hex(binary_code)

    write_output_file('../output/out_binary.txt', binary_code)
    write_output_file('../output/out_hexadeciaml.txt', hex_code)


if __name__ == "__main__":
    main()
