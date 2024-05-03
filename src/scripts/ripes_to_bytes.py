import re

def reverse_bits(bits):
    # Reverses the order of bits in a string
    return bits[::-1]

def strip_beginning(lines):
    regex = r'(?:\s|^)([01]+)$'
    binary_numbers = []
    for line in lines:
        match = re.search(regex, line)
        if match:
            binary_numbers.append(match.group(1))
    return binary_numbers

def process_bits_from_file_to_file(input_filename, output_filename):
    with open(input_filename, 'r') as input_file, open(output_filename, 'w') as output_file:
        input_file = strip_beginning(input_file)
        for line in input_file:
            line = line.strip()
            reversed_line = reverse_bits(line)
            sections = [reversed_line[i:i+8] for i in range(0, len(reversed_line), 8)]
            for section in sections:
                section = reverse_bits(section)
                output_file.write(section + '\n')

# Example usage
process_bits_from_file_to_file('../ripes_binary.txt', '../instruction_mem.mem')