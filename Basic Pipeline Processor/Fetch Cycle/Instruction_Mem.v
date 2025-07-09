module Instruction_Mem (
    input clk,
    input reset,
    input [31:0] read_address,
    output reg [31:0] instruction_out
);
    reg [31:0] I_Mem[0:63];  // Memory: 64 instructions max

    // Load instructions from hex file at the start
    initial begin
        $readmemh("instructions.hex", I_Mem); // Ensure this file exists in simulation directory
    end

    always @(posedge clk) begin
        if (reset)
            instruction_out <= 32'b0;
        else
            instruction_out <= I_Mem[read_address[7:2]]; // Word addressing
    end
endmodule
