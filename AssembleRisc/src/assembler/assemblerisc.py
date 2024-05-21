from assembler.tokenizer import reset_lineno
from assembler.parser import parser
from assembler.instruction_info import *
from assembler.immediate_generator import *


class AssembleRisc:
    def __init__(self):
        self.parse_info = {}
        self.instruction_address = 0
        self.labels_table = {}
        self.assembly_sequence = ""
        self.instruction_handlers = {
            'r_instruction': self._decode_r_instruction,
            'i_instruction': self._decode_i_instruction,
            'i_shift_instruction': self._decode_i_shift_instruction,
            'i_load_instruction': self._decode_i_load_instruction,
            'jal_instruction': self._decode_jal_instruction,
            'jalr_instruction': self._decode_jalr_instruction,
            'b_instruction': self._decode_b_instruction,
            's_instruction': self._decode_s_instruction,
            'compressed_r_instruction': self._decode_compressed_r_instruction,
            'compressed_i_instruction': self._decode_compressed_i_instruction,
            'compressed_b_instruction': self._decode_compressed_b_instruction,
            'compressed_l_load_instruction': self._decode_compressed_l_load_instruction,
            'compressed_l_store_instruction': self._decode_compressed_l_store_instruction
        }

    def _decode_r_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = R_OPCODE
        rd_bits = get_register_index_binary(instruction['rd'])
        rs1_bits = get_register_index_binary(instruction['rs1'])
        rs2_bits = get_register_index_binary(instruction['rs2'])
        funct3_bits = R_FUNCT3[instruction['opcode']]
        funct7_bits = R_FUNCT7[instruction['opcode']]
        return funct7_bits + rs2_bits + rs1_bits + funct3_bits + rd_bits + opcode_bits

    def _decode_i_instruction(self) -> str:
        instruction = self.parse_info
        if instruction['opcode'] in I_SHIFT_INSTRUCTION:
            return self._decode_i_shift_instruction()
        else:
            opcode_bits = I_OPCODE
            rd_bits = get_register_index_binary(instruction['rd'])
            rs1_bits = get_register_index_binary(instruction['rs1'])
            funct3_bits = I_FUNCT3[instruction['opcode']]
            imm_bits = get_immediate_binary_12(instruction['imm'])
            return imm_bits + rs1_bits + funct3_bits + rd_bits + opcode_bits

    def _decode_i_shift_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = I_OPCODE
        rd_bits = get_register_index_binary(instruction['rd'])
        rs1_bits = get_register_index_binary(instruction['rs1'])
        funct3_bits = I_FUNCT3[instruction['opcode']]
        imm_bits = get_immediate_binary_5(instruction['imm'])
        funct7_bits = I_SHIFT_FUNCT7[instruction['opcode']]
        return funct7_bits + imm_bits + rs1_bits + funct3_bits + rd_bits + opcode_bits

    def _decode_i_load_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = I_LOAD_OPCODE
        rd_bits = get_register_index_binary(instruction['rd'])
        rs1_bits = get_register_index_binary(instruction['rs1'])
        funct3_bits = I_LOAD_FUNCT3[instruction['opcode']]
        imm_bits = get_immediate_binary_12(instruction['imm'])
        return imm_bits + rs1_bits + funct3_bits + rd_bits + opcode_bits

    def _decode_u_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = U_OPCODE[instruction['opcode']]
        rd_bits = get_register_index_binary(instruction['rd'])
        imm_bits = get_immediate_binary_20(instruction['imm'])
        return imm_bits + rd_bits + opcode_bits

    def _decode_jal_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = JAL_OPCODE
        rd_bits = get_register_index_binary(instruction['rd'])
        target_address = self.labels_table[instruction['label']]
        imm_value = (target_address - self.instruction_address) // 2
        imm_bits = get_immediate_binary_20_jal(imm_value)
        return imm_bits + rd_bits + opcode_bits

    def _decode_jalr_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = JALR_OPCODE
        rd_bits = get_register_index_binary(instruction['rd'])
        rs1_bits = get_register_index_binary(instruction['rs1'])
        funct3_bits = JALR_FUNCT3
        imm_bits = get_immediate_binary_12(instruction['imm'])
        return imm_bits + rs1_bits + funct3_bits + rd_bits + opcode_bits

    def _decode_b_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = B_OPCODE
        rs1_bits = get_register_index_binary(instruction['rs1'])
        rs2_bits = get_register_index_binary(instruction['rs2'])
        funct3_bits = B_FUNCT3[instruction['opcode']]
        target_address = self.labels_table[instruction['label']]
        imm_value = (target_address - self.instruction_address) // 2
        imm_bits_12_10to5, imm_bits_4to1_11 = get_immediate_binary_12b(imm_value)
        return imm_bits_12_10to5 + rs2_bits + rs1_bits + funct3_bits + imm_bits_4to1_11 + opcode_bits

    def _decode_s_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = S_OPCODE
        rs1_bits = get_register_index_binary(instruction['rs1'])
        rs2_bits = get_register_index_binary(instruction['rs2'])
        funct3_bits = S_FUNCT3[instruction['opcode']]
        imm_bits_11to5, imm_bits_4to0 = get_immediate_binary_12s(instruction['imm'])
        return imm_bits_11to5 + rs2_bits + rs1_bits + funct3_bits + imm_bits_4to0 + opcode_bits

    def _decode_compressed_r_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = '01'
        if instruction['opcode'] in [INSTRUCTION_C_ADD, INSTRUCTION_C_MV]:
            opcode_bits = '10'
            if int(instruction['rd']) == 0 or int(instruction['rs2']) == 0:
                print("Illegal operands @ line " + str(instruction['lineno']))
            rd_bits = get_register_index_binary(instruction['rd'])
            rs2_bits = get_register_index_binary(instruction['rs2'])
            func_bit = COMPRESSED_R_FUNCT[instruction['opcode']]
            return '100' + func_bit + rd_bits + rs2_bits + opcode_bits
        else:
            if (
                    int(instruction['rd']) < 8 or int(instruction['rd']) > 15 or
                    int(instruction['rs2']) < 8 or int(instruction['rs2']) > 15
            ):
                print("Illegal operands @ line " + str(instruction['lineno']))
            rd_bits = get_compressed_register_index_binary(instruction['rd'])
            rs2_bits = get_compressed_register_index_binary(instruction['rs2'])
            funct_bits = COMPRESSED_R_FUNCT[instruction['opcode']]
            return '100' + '0' + '11' + rd_bits + funct_bits + rs2_bits + opcode_bits

    def _decode_compressed_i_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = COMPRESSED_I_OPCODE[instruction['opcode']]
        if instruction['opcode'] in [INSTRUCTION_C_ADDI, INSTRUCTION_C_LI, INSTRUCTION_C_LUI, INSTRUCTION_C_SLLI]:
            if instruction['opcode'] == INSTRUCTION_C_LUI and int(instruction['rd']) == 2:
                print("Illegal operands @ line " + str(instruction['lineno']))
            rd_bits = get_register_index_binary(instruction['rd'])
            imm_bits = get_immediate_binary_6(instruction['imm'])
            funct3_bits = COMPRESSED_I_FUNCT3[instruction['opcode']]
            return funct3_bits + imm_bits[0] + rd_bits + imm_bits[1:6] + opcode_bits
        else:
            if int(instruction['rd']) < 8 or int(instruction['rd']) > 15:
                print("Illegal operands @ line " + str(instruction['lineno']))
            rd_bits = get_compressed_register_index_binary(instruction['rd'])
            imm_bits = get_immediate_binary_6(instruction['imm'])
            funct2_bits = COMPRESSED_I_FUNCT2[instruction['opcode']]
            return '100' + imm_bits[0] + funct2_bits + rd_bits + imm_bits[1:6] + opcode_bits

    def _decode_compressed_b_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = '01'
        rs1_bits = get_compressed_register_index_binary(instruction['rs1'])
        funct3_bits = COMPRESSED_B_FUNCT3[instruction['opcode']]
        target_address = self.labels_table[instruction['label']]
        imm_value = (target_address - self.instruction_address) // 2
        imm_bits_8_4to3, imm_bits_7to6_2to1_5 = get_immediate_binary_8_compressed_b(imm_value)
        return funct3_bits + imm_bits_8_4to3 + rs1_bits + imm_bits_7to6_2to1_5 + opcode_bits

    def _decode_compressed_l_load_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = '00'
        rd_bits = get_compressed_register_index_binary(instruction['rd'])
        rs1_bits = get_compressed_register_index_binary(instruction['rs1'])
        funct3_bits = COMPRESSED_L_FUNCT3[instruction['opcode']]
        if int(instruction['imm']) % 4 != 0:
            print("Illegal operands @ line " + str(instruction['lineno']))
        imm_bits_5to3, imm_bits_2_6 = get_immediate_binary_5_compressed_l(instruction['imm'])
        return funct3_bits + imm_bits_5to3 + rs1_bits + imm_bits_2_6 + rd_bits + opcode_bits

    def _decode_compressed_l_store_instruction(self) -> str:
        instruction = self.parse_info
        opcode_bits = '00'
        rs2_bits = get_compressed_register_index_binary(instruction['rs2'])
        rs1_bits = get_compressed_register_index_binary(instruction['rs1'])
        funct3_bits = COMPRESSED_L_FUNCT3[instruction['opcode']]
        if int(instruction['imm']) % 4 != 0:
            print("Illegal operands @ line " + str(instruction['lineno']))
        imm_bits_5to3, imm_bits_2_6 = get_immediate_binary_5_compressed_l(instruction['imm'])
        return funct3_bits + imm_bits_5to3 + rs1_bits + imm_bits_2_6 + rs2_bits + opcode_bits

    def find_labels_pass(self) -> None:
        self.instruction_address = 0
        for line in self.assembly_sequence.splitlines(keepends=True):
            self.parse_info = parser.parse(line)
            if self.parse_info['type'] == 'label':
                self.labels_table[self.parse_info['label']] = self.instruction_address
            else:
                if 'compressed' in self.parse_info['type']:
                    self.instruction_address += 2
                elif 'instruction' in self.parse_info['type']:
                    self.instruction_address += 4

    def parse_instructions_pass(self) -> str:
        binary_code = ""
        self.instruction_address = 0

        reset_lineno()
        for line in self.assembly_sequence.splitlines(keepends=True):
            self.parse_info = parser.parse(line)
            # print(self.parse_info)

            if 'instruction' in self.parse_info['type']:
                binary_code += self.instruction_handlers[self.parse_info['type']]() + "\n"
                if 'compressed' in self.parse_info['type']:
                    self.instruction_address += 2
                else:
                    self.instruction_address += 4

        return binary_code

    def assemble(self, filename) -> str:
        try:
            with open(filename) as file:
                self.assembly_sequence = file.read()
                self.find_labels_pass()
                binary_code = self.parse_instructions_pass()
                return binary_code
        except IOError:
            print("File not found: %s" % filename)
            return ""
