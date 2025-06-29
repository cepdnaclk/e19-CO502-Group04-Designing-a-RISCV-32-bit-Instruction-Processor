import sys
import re

registers = {f"x{i}": i for i in range(32)}

def parse_reg(r):
    r = r.strip()
    if r in registers:
        return registers[r]
    raise ValueError(f"Unknown register: {r}")

def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)

def encode_r_type(funct7, rs2, rs1, funct3, rd, opcode):
    return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode

def encode_i_type(imm, rs1, funct3, rd, opcode):
    imm &= 0xfff
    return (imm << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode

def encode_s_type(imm, rs2, rs1, funct3, opcode):
    imm11_5 = (imm >> 5) & 0x7f
    imm4_0 = imm & 0x1f
    return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (imm4_0 << 7) | opcode

def encode_b_type(imm, rs2, rs1, funct3, opcode):
    # imm is a signed offset (branch target - pc)
    imm &= 0x1fff  # 13 bits
    imm12 = (imm >> 12) & 0x1
    imm10_5 = (imm >> 5) & 0x3f
    imm4_1 = (imm >> 1) & 0xf
    imm11 = (imm >> 11) & 0x1
    return (imm12 << 31) | (imm10_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (imm4_1 << 8) | (imm11 << 7) | opcode

def encode_u_type(imm, rd, opcode):
    imm &= 0xfffff000
    return (imm) | (rd << 7) | opcode

def encode_j_type(imm, rd, opcode):
    imm &= 0x1fffff  # 21 bits
    imm20 = (imm >> 20) & 0x1
    imm10_1 = (imm >> 1) & 0x3ff
    imm11 = (imm >> 11) & 0x1
    imm19_12 = (imm >> 12) & 0xff
    return (imm20 << 31) | (imm19_12 << 12) | (imm11 << 20) | (imm10_1 << 21) | (rd << 7) | opcode

def parse_imm(imm_str):
    imm_str = imm_str.strip()
    if imm_str.startswith("0x") or imm_str.startswith("0X"):
        return int(imm_str, 16)
    elif imm_str.startswith("-0x") or imm_str.startswith("-0X"):
        return -int(imm_str[1:], 16)
    else:
        return int(imm_str, 10)

def parse_mem_operand(operand):
    # format: offset(register)
    match = re.match(r'(-?\d+)\((x\d+)\)', operand)
    if not match:
        raise ValueError(f"Invalid memory operand format: {operand}")
    imm = parse_imm(match.group(1))
    base = parse_reg(match.group(2))
    return imm, base

def parse_line(line):
    line = line.strip()
    # Remove comments
    line = line.split('#')[0].strip()
    if not line:
        return None, None
    # Check for label (ends with ':')
    if line.endswith(':'):
        return 'label', line[:-1].strip()
    # Instruction parsing
    parts = re.split(r'[,\s]+', line)
    return 'instr', parts

class Assembler:
    def __init__(self):
        self.labels = {}
        self.instructions = []
        self.address = 0

    def first_pass(self, lines):
        addr = 0
        for line in lines:
            ltype, data = parse_line(line)
            if ltype == 'label':
                self.labels[data] = addr
            elif ltype == 'instr':
                self.instructions.append((addr, data))
                addr += 4

    def get_label_address(self, label):
        if label not in self.labels:
            raise ValueError(f"Undefined label: {label}")
        return self.labels[label]

    def encode(self, addr, instr):
        name = instr[0].upper()
        args = instr[1:]

        # R-type (opcode=0x33)
        if name in ('ADD', 'SUB', 'SLL', 'SLT', 'SLTU', 'XOR', 'SRL', 'SRA', 'OR', 'AND',
                    'MUL', 'MULH', 'MULHSU', 'MULHU', 'DIV', 'DIVU', 'REM', 'REMU'):
            rd = parse_reg(args[0])
            rs1 = parse_reg(args[1])
            rs2 = parse_reg(args[2])
            funct3_dict = {
                'ADD':0b000, 'SUB':0b000, 'SLL':0b001, 'SLT':0b010, 'SLTU':0b011,
                'XOR':0b100, 'SRL':0b101, 'SRA':0b101, 'OR':0b110, 'AND':0b111,
                'MUL':0b000, 'MULH':0b001, 'MULHSU':0b010, 'MULHU':0b011,
                'DIV':0b100, 'DIVU':0b101, 'REM':0b110, 'REMU':0b111
            }
            funct7_dict = {
                'ADD':0b0000000, 'SUB':0b0100000, 'SLL':0b0000000, 'SLT':0b0000000, 'SLTU':0b0000000,
                'XOR':0b0000000, 'SRL':0b0000000, 'SRA':0b0100000, 'OR':0b0000000, 'AND':0b0000000,
                'MUL':0b0000001, 'MULH':0b0000001, 'MULHSU':0b0000001, 'MULHU':0b0000001,
                'DIV':0b0000001, 'DIVU':0b0000001, 'REM':0b0000001, 'REMU':0b0000001
            }
            opcode = 0x33
            funct3 = funct3_dict[name]
            funct7 = funct7_dict[name]
            return encode_r_type(funct7, rs2, rs1, funct3, rd, opcode)

        # I-type arithmetic & logic (opcode=0x13)
        elif name in ('ADDI', 'SLTI', 'SLTIU', 'XORI', 'ORI', 'ANDI'):
            rd = parse_reg(args[0])
            rs1 = parse_reg(args[1])
            imm = parse_imm(args[2])
            funct3_dict = {
                'ADDI':0b000, 'SLTI':0b010, 'SLTIU':0b011, 'XORI':0b100,
                'ORI':0b110, 'ANDI':0b111
            }
            opcode = 0x13
            funct3 = funct3_dict[name]
            return encode_i_type(imm, rs1, funct3, rd, opcode)

        # I-type shift (opcode=0x13)
        elif name in ('SLLI', 'SRLI', 'SRAI'):
            rd = parse_reg(args[0])
            rs1 = parse_reg(args[1])
            shamt = parse_imm(args[2]) & 0x1f
            funct3_dict = {'SLLI':0b001, 'SRLI':0b101, 'SRAI':0b101}
            funct7_dict = {'SRLI':0b0000000, 'SRAI':0b0100000, 'SLLI':0b0000000}
            funct3 = funct3_dict[name]
            funct7 = funct7_dict[name]
            opcode = 0x13
            return (funct7 << 25) | (shamt << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode

        # Load instructions (opcode=0x03)
        elif name in ('LB', 'LH', 'LW', 'LBU', 'LHU'):
            rd = parse_reg(args[0])
            imm, rs1 = parse_mem_operand(args[1])
            funct3_dict = {'LB':0b000, 'LH':0b001, 'LW':0b010, 'LBU':0b100, 'LHU':0b101}
            funct3 = funct3_dict[name]
            opcode = 0x03
            return encode_i_type(imm, rs1, funct3, rd, opcode)

        # Store instructions (opcode=0x23)
        elif name in ('SB', 'SH', 'SW'):
            rs2 = parse_reg(args[0])
            imm, rs1 = parse_mem_operand(args[1])
            funct3_dict = {'SB':0b000, 'SH':0b001, 'SW':0b010}
            funct3 = funct3_dict[name]
            opcode = 0x23
            return encode_s_type(imm, rs2, rs1, funct3, opcode)

        # Branch instructions (opcode=0x63)
        elif name in ('BEQ', 'BNE', 'BLT', 'BGE', 'BLTU', 'BGEU'):
            rs1 = parse_reg(args[0])
            rs2 = parse_reg(args[1])
            label = args[2]
            target_addr = self.get_label_address(label)
            offset = target_addr - addr
            # PC-relative offset: offset must be multiple of 2; branch immediate is offset >> 1
            if offset % 2 != 0:
                raise ValueError(f"Branch target offset must be multiple of 2, got {offset}")
            imm = offset
            funct3_dict = {'BEQ':0b000, 'BNE':0b001, 'BLT':0b100, 'BGE':0b101, 'BLTU':0b110, 'BGEU':0b111}
            funct3 = funct3_dict[name]
            opcode = 0x63
            return encode_b_type(imm, rs2, rs1, funct3, opcode)

        # JAL (opcode=0x6f)
        elif name == 'JAL':
            rd = parse_reg(args[0])
            label = args[1]
            target_addr = self.get_label_address(label)
            offset = target_addr - addr
            if offset % 2 != 0:
                raise ValueError(f"JAL target offset must be multiple of 2, got {offset}")
            imm = offset
            opcode = 0x6f
            return encode_j_type(imm, rd, opcode)

        # JALR (opcode=0x67)
        elif name == 'JALR':
            rd = parse_reg(args[0])
            rs1 = parse_reg(args[1])
            imm = parse_imm(args[2])
            opcode = 0x67
            funct3 = 0b000
            return encode_i_type(imm, rs1, funct3, rd, opcode)

        # LUI (opcode=0x37)
        elif name == 'LUI':
            rd = parse_reg(args[0])
            imm = parse_imm(args[1])
            opcode = 0x37
            return encode_u_type(imm, rd, opcode)

        # AUIPC (opcode=0x17)
        elif name == 'AUIPC':
            rd = parse_reg(args[0])
            imm = parse_imm(args[1])
            opcode = 0x17
            return encode_u_type(imm, rd, opcode)

        # FENCE (opcode=0x0f)
        elif name == 'FENCE':
            # FENCE and FENCE.I
            # Format: fence pred,succ
            # We'll parse pred and succ if provided, else zero
            # FENCE.I has funct3=1, FENCE has funct3=0
            opcode = 0x0f
            if len(args) == 0:
                # plain FENCE with pred=0 succ=0
                imm = 0
                funct3 = 0
            else:
                # e.g. fence iorw,iorw
                parts = args[0].split(',')
                pred = parts[0] if len(parts) > 0 else ''
                succ = parts[1] if len(parts) > 1 else ''
                def fence_flag(s):
                    flags = 0
                    if 'i' in s: flags |= 0x1
                    if 'o' in s: flags |= 0x2
                    if 'r' in s: flags |= 0x4
                    if 'w' in s: flags |= 0x8
                    return flags
                pred_bits = fence_flag(pred)
                succ_bits = fence_flag(succ)
                imm = (pred_bits << 4) | succ_bits
                funct3 = 0
            return (imm << 20) | (funct3 << 12) | opcode

        elif name == 'FENCE.I':
            opcode = 0x0f
            funct3 = 1
            imm = 0
            return (imm << 20) | (funct3 << 12) | opcode

        else:
            raise ValueError(f"Unsupported instruction: {name}")

    def assemble(self, lines):
        self.first_pass(lines)
        output = []
        for addr, instr in self.instructions:
            machine_code = self.encode(addr, instr)
            output.append(machine_code)
        return output

def main():
    if len(sys.argv) != 3:
        print("Usage: python assembler.py input.s output.hex")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, 'r') as f:
        lines = f.readlines()

    asm = Assembler()
    try:
        machine_codes = asm.assemble(lines)
    except Exception as e:
        print(f"Assembly error: {e}")
        sys.exit(1)

    with open(output_file, 'w') as f:
        for code in machine_codes:
            f.write(f"{code:08x}\n")

    print(f"Assembled {len(machine_codes)} instructions to {output_file}")

if __name__ == "__main__":
    main()
