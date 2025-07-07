module ImmGen (
    input  [31:0] instr,
    output reg [31:0] immOut
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011, // I-type: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
            7'b0000011, // I-type: Load instructions (LB, LH, LW, etc.)
            7'b1100111: // I-type: JALR
                immOut = {{20{instr[31]}}, instr[31:20]};

            7'b0100011: // S-type: Store instructions (SB, SH, SW)
                immOut = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            7'b1100011: // B-type: BEQ, BNE, BLT, BGE, etc.
                immOut = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            7'b0110111, // U-type: LUI
            7'b0010111: // U-type: AUIPC
                immOut = {instr[31:12], 12'b0};

            7'b1101111: // J-type: JAL
                immOut = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

            default:
                immOut = 32'b0;
        endcase
    end

endmodule
