import re
import serial
import time

def reverse_bits(bits):
    # Reverses the order of bits in a string
    return bits[::-1]

def strip_beginning(lines):
    regex = r'(^[01]{16,32})$'
    binary_numbers = []
    for line in lines:
        match = re.search(regex, line)
        if match:
            binary_numbers.append(match.group(0))
    return binary_numbers

def send_hex_over_uart(input_filename):
    ser = serial.Serial('/dev/ttyUSB1', 4800)
    ser.setRTS(False)
    ser.setRTS(True)

    with open(input_filename, 'r') as input_file:
        input_file = strip_beginning(input_file)
        for line in input_file:
            line = line.strip()
            reversed_line = reverse_bits(line)
            sections = [reversed_line[i:i+8] for i in range(0, len(reversed_line), 8)]
            for section in sections:
                section = reverse_bits(section)
                hex_value = hex(int(section, 2))[2:].upper().zfill(2)
                hex_string = '\\x' + hex_value
                ser.write(bytearray.fromhex(hex_value))
                time.sleep(0.01)

# Example usage
send_hex_over_uart('/home/modica/AssembleRisc/output/out_binary.txt')
