module RItype (
    input  wire [31:0] a,        // rs1
    input  wire [31:0] b,        // rs2 or imm
    input  wire [5:0]  aluSelect, // ALU control signal
    output reg  [31:0] result     // ALU result
);

    always @(*) begin
        case (aluSelect)
            6'b010011: result = a + b;                    // ADDI
            6'b011000: result = a & b;                    // ANDI
            6'b010111: result = a | b;                    // ORI
            6'b010110: result = a ^ b;                    // XORI
            6'b011001: result = a << b[4:0];              // SLLI
            6'b011010: result = a >> b[4:0];              // SRLI
            6'b011011: result = $signed(a) >>> b[4:0];    // SRAI
            6'b010100: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLTI
            6'b010101: result = (a < b) ? 32'd1 : 32'd0;   // SLTIU

            6'b011100: result = a + b;                    // ADD
            6'b100100: result = a - b;                    // SUB
            6'b100011: result = a & b;                    // AND
            6'b100010: result = a | b;                    // OR
            6'b100000: result = a ^ b;                    // XOR
            6'b011101: result = a << b[4:0];              // SLL
            6'b100001: result = a >> b[4:0];              // SRL
            6'b100101: result = $signed(a) >>> b[4:0];    // SRA
            6'b011110: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
            6'b011111: result = (a < b) ? 32'd1 : 32'd0;   // SLTU
            default:   result = 32'b0;
        endcase
    end

endmodule

