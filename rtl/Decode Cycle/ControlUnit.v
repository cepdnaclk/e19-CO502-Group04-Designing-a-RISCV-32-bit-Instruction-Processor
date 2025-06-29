module ControlUnit (
    input  [31:0] instruction,
    output reg [5:0] aluSelect,   // Fixed width to 6 bits
    output reg        MemWrite,
    output reg        MemRead,
    output reg        ImmSelect,
    output reg        PCSelect,
    output reg        regWrite,
    output reg        Jtype
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    always @(*) begin
        // Default values
        aluSelect   = 6'b0;
        MemWrite    = 0;
        MemRead     = 0;
        ImmSelect   = 0;
        PCSelect    = 0;
        regWrite    = 0;
        Jtype       = 0;

        case (opcode)
            7'b1101111: begin // JAL
                aluSelect  = 6'b000011;
                regWrite   = 1;
                Jtype      = 1;
                ImmSelect  = 1;
                PCSelect   = 1;
            end

            7'b1100111: begin // JALR
                aluSelect  = 6'b000100;
                regWrite   = 1;
                Jtype      = 1;
                ImmSelect  = 1;
                PCSelect   = 1;
            end

            7'b1100011: begin // Branch
                case (funct3)
                    3'b000: aluSelect = 6'b000101; // BEQ
                    3'b001: aluSelect = 6'b000110; // BNE
                    3'b100: aluSelect = 6'b000111; // BLT
                    3'b101: aluSelect = 6'b001000; // BGE
                    3'b110: aluSelect = 6'b001001; // BLTU
                    3'b111: aluSelect = 6'b001010; // BGEU
                endcase
            end

            7'b0000011: begin // Load
                MemRead   = 1;
                ImmSelect = 1;
                regWrite  = 1;
                case (funct3)
                    3'b000: begin aluSelect = 6'b001011; end // LB
                    3'b001: begin aluSelect = 6'b001100; end // LH
                    3'b010: begin aluSelect = 6'b001101; end // LW
                    3'b100: begin aluSelect = 6'b001110; end // LBU
                    3'b101: begin aluSelect = 6'b001111; end // LHU
                endcase
            end

            7'b0100011: begin // Store
                MemWrite  = 1;
                ImmSelect = 1;
                case (funct3)
                    3'b000: begin aluSelect = 6'b010000; end // SB
                    3'b001: begin aluSelect = 6'b010001; end // SH
                    3'b010: begin aluSelect = 6'b010010; end // SW
                endcase
            end

            7'b0010011: begin // I-type ALU
                ImmSelect = 1;
                regWrite  = 1;
                case (funct3)
                    3'b000: begin
                        if (instruction[19:15] == 5'b00000 && instruction[11:7] == 5'b00000 && instruction[31:20] == 12'b0)
                            ; // NOP — do nothing
                        else
                            aluSelect = 6'b010011; // ADDI
                    end
                    3'b010: aluSelect = 6'b010100; // SLTI
                    3'b011: aluSelect = 6'b010101; // SLTIU
                    3'b100: aluSelect = 6'b010110; // XORI
                    3'b110: aluSelect = 6'b010111; // ORI
                    3'b111: aluSelect = 6'b011000; // ANDI
                    3'b001: if (funct7 == 7'b0000000)
                                aluSelect = 6'b011001; // SLLI
                    3'b101: case (funct7)
                                7'b0000000: aluSelect = 6'b011010; // SRLI
                                7'b0100000: aluSelect = 6'b011011; // SRAI
                            endcase
                endcase
            end

            7'b0110011: begin // R-type or RV32M
                regWrite = 1;
                case (funct7)
                    7'b0000000: begin
                        case (funct3)
                            3'b000: aluSelect = 6'b011100; // ADD
                            3'b001: aluSelect = 6'b011101; // SLL
                            3'b010: aluSelect = 6'b011110; // SLT
                            3'b011: aluSelect = 6'b011111; // SLTU
                            3'b100: aluSelect = 6'b100000; // XOR
                            3'b101: aluSelect = 6'b100001; // SRL
                            3'b110: aluSelect = 6'b100010; // OR
                            3'b111: aluSelect = 6'b100011; // AND
                        endcase
                    end
                    7'b0100000: begin
                        case (funct3)
                            3'b000: aluSelect = 6'b100100; // SUB
                            3'b101: aluSelect = 6'b100101; // SRA
                        endcase
                    end
                    7'b0000001: begin
                        case (funct3)
                            3'b000: aluSelect = 6'b100110; // MUL
                            3'b001: aluSelect = 6'b100111; // MULH
                            3'b010: aluSelect = 6'b101000; // MULHSU
                            3'b011: aluSelect = 6'b101001; // MULHU
                            3'b100: aluSelect = 6'b101010; // DIV
                            3'b101: aluSelect = 6'b101011; // DIVU
                            3'b110: aluSelect = 6'b101100; // REM
                            3'b111: aluSelect = 6'b101101; // REMU
                        endcase
                    end
                endcase
            end

            7'b0010111: begin // AUIPC
                aluSelect  = 6'b000010;
                ImmSelect  = 1;
                PCSelect   = 1;
                regWrite   = 1;
            end

            7'b0110111: begin // LUI
                aluSelect  = 6'b000001;
                ImmSelect  = 1;
                regWrite   = 1;
            end

            7'b0001111: begin // FENCE
                // Treated as NOP
                aluSelect = 6'b0;
            end

            7'b1110011: begin // ECALL, EBREAK
                // Treated as NOP or illegal
                aluSelect = 6'b0;
            end
        endcase
    end

endmodule
