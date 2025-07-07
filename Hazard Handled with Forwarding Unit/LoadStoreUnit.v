module LoadStoreUnit (
    input  wire [31:0] rs1,        // Base address register
    input  wire [31:0] imm,        // Immediate value
    input  wire [5:0]  aluSelect,  // ALU select signal from control unit
    output reg  [31:0] address     // Computed address
);

    always @(*) begin
        if ((aluSelect >= 6'b001011) && (aluSelect <= 6'b010010))
            address = rs1 + imm;
        else
            address = 32'b0;
    end

endmodule


// 001011 -> LB
// 001100 -> LH
// 001101 -> LW
// 001110 -> LBU
// 001111 -> LHU
// 010000 -> SB
// 010001 -> SH
// 010010 -> SW
