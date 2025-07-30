module muldiv(
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    input  wire [5:0]  aluSelect,
    output reg  [31:0] result
);

    wire signed [63:0] signed_product  = $signed(rs1) * $signed(rs2);
    wire signed [63:0] signed_product1 = $signed(rs1) * rs2;
    wire [63:0] unsigned_product       = rs1 * rs2;

    always @(*) begin
        case (aluSelect)
            6'b100110: result = rs1 * rs2;                                // MUL (lower 32 bits)
            6'b100111: result = signed_product[63:32];                    // MULH
            6'b101000: result = signed_product1[63:32];                   // MULHSU
            6'b101001: result = unsigned_product[63:32];                  // MULHU
            6'b101010: result = (rs2 != 0) ? $signed(rs1) / $signed(rs2) : 32'b0; // DIV
            6'b101011: result = (rs2 != 0) ? rs1 / rs2 : 32'b0;           // DIVU
            6'b101100: result = (rs2 != 0) ? $signed(rs1) % $signed(rs2) : 32'b0; // REM
            6'b101101: result = (rs2 != 0) ? rs1 % rs2 : 32'b0;           // REMU
            default:    result = 32'b0;
        endcase
    end

endmodule
