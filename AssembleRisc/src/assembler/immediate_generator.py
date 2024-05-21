def get_register_index_binary(index) -> str:
    return '{0:05b}'.format(int(index))


def get_compressed_register_index_binary(index) -> str:
    return '{0:03b}'.format(int(index) - 8)


def get_immediate_binary_5(value) -> str:
    value &= 0x1f
    return '{0:05b}'.format(int(value))


def get_immediate_binary_6(value) -> str:
    value &= 0x3f
    return '{0:06b}'.format(int(value))


def get_immediate_binary_8(value) -> str:
    value &= 0xff
    return '{0:08b}'.format(int(value))


def get_immediate_binary_12(value) -> str:
    value &= 0xfff
    return '{0:012b}'.format(int(value))


def get_immediate_binary_12b(value) -> (str, str):
    imm_bits = get_immediate_binary_12(value)
    imm_bits_12_10to5 = imm_bits[0] + imm_bits[2:8]
    imm_bits_4to1_11 = imm_bits[8:12] + imm_bits[1]
    return imm_bits_12_10to5, imm_bits_4to1_11


def get_immediate_binary_12s(value) -> (str, str):
    imm_bits = get_immediate_binary_12(value)
    imm_bits_11to5 = imm_bits[0:7]
    imm_bits_4to0 = imm_bits[7:12]
    return imm_bits_11to5, imm_bits_4to0


def get_immediate_binary_20(value) -> str:
    value &= 0xfffff
    return '{0:020b}'.format(int(value))


def get_immediate_binary_20_jal(value) -> str:
    imm_bits = get_immediate_binary_20(value)
    return imm_bits[0] + imm_bits[10:20] + imm_bits[9] + imm_bits[1:9]


def get_immediate_binary_8_compressed_b(value) -> (str, str):
    imm_bits = get_immediate_binary_8(value)
    imm_bits_7to6_2to1_5 = imm_bits[1:3] + imm_bits[6:8] + imm_bits[3]
    imm_bits_8_4to3 = imm_bits[0] + imm_bits[4:6]
    return imm_bits_8_4to3, imm_bits_7to6_2to1_5


def get_immediate_binary_5_compressed_l(value) -> (str, str):
    value //= 4
    imm_bits = get_immediate_binary_5(value)
    imm_bits_5to3 = imm_bits[1:4]
    imm_bits_2_6 = imm_bits[4] + imm_bits[0]
    return imm_bits_5to3, imm_bits_2_6
