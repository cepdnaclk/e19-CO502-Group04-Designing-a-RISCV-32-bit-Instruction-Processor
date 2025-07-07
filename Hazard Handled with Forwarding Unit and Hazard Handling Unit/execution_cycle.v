module execution_cycle(
    input [31:0] PCD, ImmGenOutD, RegOut1D, RegOut2D, ALUOutfromM, ResultOutfromWB,
    input [5:0] ALUSelectD,
    input [1:0] ForwardAE, ForwardBE,
    input [4:0] WriteAddressD, Rs1D, Rs2D,
    input JtypeD, RegWriteD, MemReadD, MemWriteD, ImmSelectD, PCSelectD,
    output [31:0] PCPlusImmM, ALUOutM, StoreCounterOutM,
    output [5:0] ALUSelectM,
    output [4:0] WriteAddressM, Rs1FU, Rs2FU, RdE2HDU,
    output JtypeM, RegWriteM, MemReadM, MemWriteM, BranchM, MemReadE2HDU
);

    wire [31:0] ShifterOutE;
    wire [31:0] RegOut1Fwd, RegOut2Fwd, Mux1outE, Mux2EdashOut;

    // Shift left for branch offset calculation
    ShiftLeft1 ShiftLeft1E(
        .in(ImmGenOutD),
        .out(ShifterOutE)
    );

    // Forwarding stage: apply forwarding BEFORE ImmSelect
    Mux_3_by_1 Mux_Reg1Fwd (
        .select(ForwardAE),
        .in1(RegOut1D),
        .in2(ResultOutfromWB),
        .in3(ALUOutfromM),
        .out(RegOut1Fwd)
    );

    Mux_3_by_1 Mux_Reg2Fwd (
        .select(ForwardBE),
        .in1(RegOut2D),
        .in2(ResultOutfromWB),
        .in3(ALUOutfromM),
        .out(RegOut2Fwd)
    );

    // Select ALU input A: either PC or forwarded RegOut1
    Mux Mux1E(
        .select(PCSelectD), 
        .B(RegOut1Fwd), 
        .A(PCD), 
        .Mux_out(Mux1outE)
    );

    // Select ALU input B: either forwarded RegOut2 or ImmGenOut
    Mux Mux2E(
        .select(ImmSelectD), 
        .B(RegOut2Fwd), 
        .A(ImmGenOutD), 
        .Mux_out(Mux2EdashOut)
    );

    // ALU
    ALU ALUE(
        .rs1(Mux1outE),
        .rs2(Mux2EdashOut),
        .aluSelect(ALUSelectD),
        .result(ALUOutM),
        .branch_taken(BranchM)
    );

    // Adder for branch target
    Adder AdderE(
        .in_1(PCD),
        .in_2(ShifterOutE),
        .Sum_out(PCPlusImmM)
    );

    // Store value converter (no forwarding needed)
    StoreConverter StoreConverterE(
        .inputData(RegOut2D),
        .aluSelect(ALUSelectD),
        .outputData(StoreCounterOutM)
    );

    // Pass-through pipeline values to MEM stage
    assign WriteAddressM = WriteAddressD;
    assign Rs1FU = Rs1D;
    assign Rs2FU = Rs2D;
    assign JtypeM = JtypeD;
    assign RegWriteM = RegWriteD;
    assign MemReadM = MemReadD;
    assign MemWriteM = MemWriteD;
    assign ALUSelectM = ALUSelectD;
    assign RdE2HDU = WriteAddressD; // For Hazard Detection Unit
    assign MemReadE2HDU = MemReadD; // For Hazard Detection Unit

endmodule
