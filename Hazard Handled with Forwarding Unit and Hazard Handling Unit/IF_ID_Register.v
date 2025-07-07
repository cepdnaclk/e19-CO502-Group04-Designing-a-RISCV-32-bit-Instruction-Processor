module IF_ID_Register (
    input         clk,
    input         StallD,    // Flush signal for Execute stage
    input         reset,
    input  [31:0] PCD,        // PC from Fetch stage
    input  [31:0] InstrD,     // Instruction from Fetch stage
    output reg [31:0] PCF2D,  // PC to Decode stage
    output reg [31:0] InstrF2D // Instruction to Decode stage

);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PCF2D <= 32'b0;
            InstrF2D <= 32'b0;
        end else if (StallD) begin
            PCF2D <= PCF2D;
            InstrF2D <= InstrF2D;
        end else begin
            PCF2D <= PCD;
            InstrF2D <= InstrD;
        end
    end

endmodule
