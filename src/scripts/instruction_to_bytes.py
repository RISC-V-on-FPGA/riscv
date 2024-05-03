def reverse_bits(bits):
    # Reverses the order of bits in a string
    return bits[::-1]

def process_bits_from_file_to_file(input_filename, output_filename):
    with open(input_filename, 'r') as input_file, open(output_filename, 'w') as output_file:
        for line in input_file:
            line = line.strip()
            reversed_line = reverse_bits(line)
            sections = [reversed_line[i:i+8] for i in range(0, len(reversed_line), 8)]
            for section in sections:
                section = reverse_bits(section)
                output_file.write(section + '\n')

# Example usage
process_bits_from_file_to_file('../instruction_mem.txt', '../instruction_mem.mem')