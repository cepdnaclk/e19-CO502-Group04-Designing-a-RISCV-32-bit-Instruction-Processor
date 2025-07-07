module Fetch_cycle(clk, reset, PCPlusImmM, ALUOutM, BranchM, JtypeM, PCD, InstrD, StallF);

    input clk, reset, BranchM, JtypeM, StallF;
    input [31:0] PCPlusImmM, ALUOutM;
    output [31:0] PCD, InstrD;

    wire [31:0] PCInF, PCOutF, InstrF, PCPlus4F, JtypeMuxOutF;

    Mux JtypeEMux (
            .select(JtypeM), 
            .A(ALUOutM), 
            .B(PCPlusImmM), 
            .Mux_out(JtypeMuxOutF)
            );

    Mux BranchEMux (
            .select(BranchM), 
            .A(JtypeMuxOutF), 
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