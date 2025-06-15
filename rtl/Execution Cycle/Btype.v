module Btype (
    input  [5:0] aluSelect,
    input  [31:0] rs1,
    input  [31:0] rs2,
    output reg branch_taken,
    output reg [31:0] result
);

    always @(*) begin
        case (aluSelect)
            6'b001010: branch_taken = (rs1 == rs2);  // BEQ
            6'b001100: branch_taken = (rs1 != rs2);  // BNE
            6'b001110: branch_taken = ($signed(rs1) < $signed(rs2));  // BLT
            6'b010000: branch_taken = ($signed(rs1) >= $signed(rs2)); // BGE
            6'b010010: branch_taken = (rs1 < rs2);   // BLTU
            6'b010100: branch_taken = (rs1 >= rs2);  // BGEU
            default: branch_taken = 0;
        endcase
    end

endmodule
