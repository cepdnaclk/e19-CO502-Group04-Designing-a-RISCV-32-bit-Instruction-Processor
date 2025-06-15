module Utype (
    input  wire [31:0] pc,         // Program Counter
    input  wire [31:0] imm_u,      // 20-bit immediate shifted as needed
    input  wire [5:0]  aluSelect,  // 00010 for AUIPC, 00001 for LUI
    output reg  [31:0] result      // Result to write to rd
);

    always @(*) begin
        case (aluSelect)
            5'b000010: result = pc + imm_u;   // AUIPC
            5'b000001: result = imm_u;        // LUI
            default:  result = 32'b0;
        endcase
    end

endmodule
