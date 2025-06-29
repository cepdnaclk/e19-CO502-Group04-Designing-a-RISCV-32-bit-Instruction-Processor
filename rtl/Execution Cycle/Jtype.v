module Jtype (
    input  wire [31:0] pc,        // Source register for JALR
    input  wire [31:0] imm,        // Immediate value
    input  wire [5:0]  aluSelect,  // 3'b001 for JAL, 3'b010 for JALR
    output reg  [31:0] next_pc     // Target address
);

    always @(*) begin
        case (aluSelect)
            6'b000011: begin
                // JAL
                next_pc = pc + imm;
            end
            6'b000100: begin
                // JALR
                next_pc = (pc + imm) & 32'hFFFFFFFE; // clear LSB
            end
            default: begin
                next_pc = 32'b0;
            end
        endcase
    end

endmodule
