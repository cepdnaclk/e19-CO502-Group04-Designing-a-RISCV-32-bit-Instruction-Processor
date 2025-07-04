module Btype (
    input  [5:0] aluSelect,
    input  [31:0] rs1,
    input  [31:0] rs2,
    output reg branch_taken,
    output reg [31:0] result
);

    always @(*) begin
        case (aluSelect)
            6'b000101: branch_taken = (rs1 == rs2);  // BEQ
            6'b000110: branch_taken = (rs1 != rs2);  // BNE
            6'b000111: branch_taken = ($signed(rs1) < $signed(rs2));  // BLT
            6'b001000: branch_taken = ($signed(rs1) >= $signed(rs2)); // BGE
            6'b001001: branch_taken = (rs1 < rs2);   // BLTU
            6'b001010: branch_taken = (rs1 >= rs2);  // BGEU
            6'b000011: branch_taken = 1;
            6'b000100: branch_taken = 1;
            default: branch_taken = 0;
        endcase
    end

endmodule
