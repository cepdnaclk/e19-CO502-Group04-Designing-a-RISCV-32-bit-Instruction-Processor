module execution_cycle(PCD, WriteAddressD, WriteAddressM, ImmGenOutD, RegOut2D, RegOut1D, JtypeD, RegWriteD, MemReadD, MemWriteD, ImmSelectD, PCSelectD, ALUSelectD, JtypeM, RegWriteM, MemReadM, MemWriteM, BranchM, ALUOutM, ALUSelectM, StoreCounterOutM, PCPlusImmM);

    input [31:0] PCD, ImmGenOutD, RegOut1D, RegOut2D;
    input [5:0] ALUSelectD;
    input [4:0] WriteAddressD;
    input JtypeD, RegWriteD, MemReadD, MemWriteD, ImmSelectD, PCSelectD;
    output [31:0] PCPlusImmM, ALUOutM, StoreCounterOutM;
    output [5:0] ALUSelectM;
    output [4:0] WriteAddressM;
    output JtypeM, RegWriteM, MemReadM, MemWriteM, BranchM;

    wire [31:0] ShifterOutE, Mux2outE, Mux1outE;

    ShiftLeft1 ShiftLeft1E(
        .in(ImmGenOutD),
        .out(ShifterOutE)
    );

    assign WriteAddressM = WriteAddressD;

    Mux Mux2E(
        .select(ImmSelectD), 
        .B(RegOut2D), 
        .A(ImmGenOutD), 
        .Mux_out(Mux2outE)
    );
    
    Mux Mux1E(
        .select(PCSelectD), 
        .B(RegOut1D), 
        .A(PCD), 
        .Mux_out(Mux1outE)
    );

    StoreConverter StoreConverterE(
        .inputData(RegOut2D),
        .aluSelect(ALUSelectD),
        .outputData(StoreCounterOutM)
    );

    ALU ALUE(
        .rs1(Mux1outE),             // First source register (32-bit)
        .rs2(Mux2outE),             // Second source register (32-bit)
        .aluSelect(ALUSelectD),        // ALU control signal (6-bit)
        .result(ALUOutM),      // ALU result (32-bit)
        .branch_taken(BranchM)            // Branch decision (1 bit)
    );

    Adder AdderE(
        .in_1(PCD), 
        .in_2(ShifterOutE), 
        .Sum_out(PCPlusImmM)
    );

    assign JtypeM = JtypeD;
    assign RegWriteM = RegWriteD;
    assign MemReadM = MemReadD;
    assign MemWriteM = MemWriteD;
    assign ALUSelectM = ALUSelectD;


endmodule