module Fetch_cycle(clk, reset, PC_Updated_Select, PC_Updated_CHU, PCD, InstrD, StallF);

    input clk, reset, StallF, PC_Updated_Select;
    input [31:0] PC_Updated_CHU;
    output [31:0] PCD, InstrD;

    wire [31:0] PCInF, PCOutF, InstrF, PCPlus4F;

    Mux BranchEMux (
            .select(PC_Updated_Select), 
            .A(PC_Updated_CHU), 
            .B(PCPlus4F), 
            .Mux_out(PCInF)
            );

    Program_Counter Program_Counter_Fetch(
            .StallF(StallF),
            .clk(clk), 
            .reset(reset), 
            .PC_in(PCInF), 
            .PC_out(PCOutF)
            );

    Adder PCPlus4(
            .in_1(PCOutF), 
            .in_2(32'h00000004), 
            .Sum_out(PCPlus4F)
            );

    Instruction_Mem Instr_Mem(
            .clk(clk),
            .reset(reset),
            .read_address(PCOutF),
            .instruction_out(InstrF)
            );

    assign PCD = PCOutF;
    assign InstrD = InstrF;

endmodule