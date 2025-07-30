module top_cpu(input clk, input reset, output [31:0] probe_output);

    // Internal registers
    wire [31:0] PCF2D, InstrF2D, ReadOut1D2E, ReadOut2D2E, ImmGenOutD2E, PCD2E;
    wire [31:0] ALUOutE2M, StoreCounterOutE2M, PCPlusImmE2M;
    wire [31:0] DataMemOutM2W, ALUOutM2W;

    wire JtypeD2E, RegWriteD2E, PCSelectD2E, ImmSelectD2E, MemReadD2E, MemWriteD2E;
    wire JtypeE2M, RegWriteE2M, MemReadE2M, MemWriteE2M, BranchE2M;
    wire JtypeM2W, RegWriteM2W, MemReadM2W;

    wire [5:0] ALUSelectD2E, ALUSelectE2M, ALUSelectM2W;
    wire [4:0] WriteAddressD2E, WriteAddressE2M, WriteAddressM2W, Rs1D2E, Rs2D2E;

    // Internal wires
    wire [31:0] PCD, InstrD, ReadOut1E, ReadOut2E, ImmGenOutE, PCE, ALUOutfromM, ResultOutfromWB;
    wire [31:0] ALUOutM, StoreCounterOutM, PCPlusImmM, PCPlusImm;
    wire [31:0] ALUOut, DataMemOutW, ALUOutW, RegInData;

    wire JtypeE, RegWriteE, PCSelectE, ImmSelectE, MemReadE, MemWriteE, RegWriteM2FU, RegWriteW2FU;
    wire JtypeM, RegWriteM, MemReadM, MemWriteM, BranchM;
    wire Jtype, Branch, JtypeW, RegWriteW, MemReadW, RegWrite;

    wire [5:0] ALUSelectE, ALUSelectM, ALUSelectW;
    wire [4:0] WriteAddressE, WriteAddressM, WriteAddress, WriteAddressW, WriteAddressM2FU, WriteAddressW2FU;
    wire [4:0] Rs1E2FU, Rs2E2FU, Rs1E, Rs2E;
    wire [1:0] ForwardAE, ForwardBE;

    wire [4:0] Rs1D2HDU, Rs2D2HDU, RdE2HDU; // For Hazard Detection Unit
    wire MemReadE2HDU, StallF, StallD, FlushE;

    wire PC_Updated_Select, FlushD2CHU;
    wire [31:0] PC_Updated_CHU, PCD2CHU, ImmGenOutD2CHU, ReadOut1D2CHU, ReadOut2D2CHU;
    wire [5:0] ALUSelectD2CHU;

    wire [4:0] Rs1D2CHU, Rs2D2CHU, RdE2CHU, RdM2CHU, RdW2CHU;
    wire [31:0] ALUOutE2CHU, ALUOutM2CHU, MuxOutW2CHU;
    wire RegWriteE2CHU, RegWriteM2CHU, RegWriteW2CHU;

    // Module instantiations
    Fetch_cycle fetch_cycle_Imp (
        .StallF(StallF),
        .clk(clk), 
        .reset(reset), 
        .PCD(PCD), 
        .InstrD(InstrD),
        .PC_Updated_Select(PC_Updated_Select),
        .PC_Updated_CHU(PC_Updated_CHU)
    );

    decode_cycle decode_cycle_Imp (
        .clk(clk), 
        .reset(reset), 
        .WriteAddressE(WriteAddressE),  
        .JtypeE(JtypeE), 
        .RegWriteE(RegWriteE), 
        .ALUSelectE(ALUSelectE), 
        .PCSelectE(PCSelectE), 
        .ImmSelectE(ImmSelectE), 
        .MemReadE(MemReadE), 
        .MemWriteE(MemWriteE), 
        .ReadOut1E(ReadOut1E), 
        .ReadOut2E(ReadOut2E), 
        .ImmGenOutE(ImmGenOutE), 
        .PCE(PCE),
        .instructionF(InstrF2D), 
        .PCF(PCF2D), 
        .WriteAddressW(WriteAddress), 
        .RegWriteW(RegWrite), 
        .writeDataW(RegInData),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .Rs1D2HDU(Rs1D2HDU),
        .Rs2D2HDU(Rs2D2HDU),
        .FlushE(FlushE),
        .ReadData1CHU(ReadOut1D2CHU),
        .ReadData2CHU(ReadOut2D2CHU),
        .PCCHU(PCD2CHU),
        .ImmCHU(ImmGenOutD2CHU),
        .ALUSelectCHU(ALUSelectD2CHU),
        .Rs1D2CHU(Rs1D2CHU),
        .Rs2D2CHU(Rs2D2CHU)
    );

    execution_cycle execution_cycle_Imp (
        .PCD(PCD2E), 
        .WriteAddressD(WriteAddressD2E), 
        .ImmGenOutD(ImmGenOutD2E), 
        .RegOut2D(ReadOut2D2E), 
        .RegOut1D(ReadOut1D2E), 
        .JtypeD(JtypeD2E), 
        .RegWriteD(RegWriteD2E), 
        .MemReadD(MemReadD2E), 
        .MemWriteD(MemWriteD2E), 
        .ImmSelectD(ImmSelectD2E), 
        .PCSelectD(PCSelectD2E), 
        .ALUSelectD(ALUSelectD2E), 
        .WriteAddressM(WriteAddressM),  
        .RegWriteM(RegWriteM), 
        .MemReadM(MemReadM), 
        .MemWriteM(MemWriteM), 
        .ALUOutM(ALUOutM), 
        .ALUSelectM(ALUSelectM), 
        .StoreCounterOutM(StoreCounterOutM),
        .PCPlusImmM(PCPlusImmM),
        .Rs1FU(Rs1E2FU),
        .Rs2FU(Rs2E2FU),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ALUOutfromM(ALUOutfromM),
        .ResultOutfromWB(ResultOutfromWB),
        .Rs1D(Rs1D2E),
        .Rs2D(Rs2D2E),
        .RdE2HDU(RdE2HDU),
        .MemReadE2HDU(MemReadE2HDU),
        .JtypeM(JtypeM),
        .RegWrite2CHU(RegWriteE2CHU),
        .ALUOutE2CHU(ALUOutE2CHU),
        .RdEAddressCHU(RdE2CHU)
    );

    Mem_cycle Mem_cycle_Imp (
        .clk(clk), 
        .reset(reset), 
        .PCPlusImmE(PCPlusImmE2M), 
        .JtypeE(JtypeE2M), 
        .RegWriteE(RegWriteE2M), 
        .MemWriteE(MemWriteE2M), 
        .MemReadE(MemReadE2M), 
        .ALUOutE(ALUOutE2M), 
        .StoreConverterE(StoreCounterOutE2M), 
        .ALUSelectE(ALUSelectE2M), 
        .WriteAddressE(WriteAddressE2M),
        .BranchE(BranchE2M), 
        .PCPlusImmF(PCPlusImm), 
        .JtypeF(Jtype), 
        .JtypeW(JtypeW), 
        .RegWriteW(RegWriteW), 
        .MemReadW(MemReadW), 
        .DataMemOutW(DataMemOutW), 
        .ALUOutW(ALUOutW), 
        .ALUSelectW(ALUSelectW), 
        .WriteAddressW(WriteAddressW), 
        .BranchF(Branch), 
        .ALUOutF(ALUOut),
        .ALUOut2E(ALUOutfromM),
        .RegWrite2FU(RegWriteM2FU),
        .WriteAddress2FU(WriteAddressM2FU),
        .ALUOut2CHU(ALUOutM2CHU),
        .RdEAddressCHU(RdM2CHU),
        .RegWrite2CHU(RegWriteM2CHU)
    );

    writeBack_cycle writeBack_cycle_Imp (
        .RegWriteM(RegWriteM2W), 
        .JtypeM(JtypeM2W), 
        .MemReadM(MemReadM2W), 
        .DataMemOutM(DataMemOutM2W), 
        .ALUOutM(ALUOutM2W), 
        .ALUSelectM(ALUSelectM2W), 
        .WriteAddressM(WriteAddressM2W), 
        .RegWriteD(RegWrite), 
        .RegInDataD(RegInData), 
        .WriteAddressD(WriteAddress),
        .ResultOut2E(ResultOutfromWB),
        .RegWrite2FU(RegWriteW2FU),
        .WriteAddress2FU(WriteAddressW2FU),
        .MemOut2CHU(MuxOutW2CHU),
        .RegWrite2CHU(RegWriteW2CHU),
        .WriteAddress2CHU(RdW2CHU)
    );

    forwarding_unit FU(
        .reset(reset), 
        .RegWriteM(RegWriteM2FU), 
        .RegWriteW(RegWriteW2FU), 
        .RD_M(WriteAddressM2FU), 
        .RD_W(WriteAddressW2FU), 
        .Rs1_E(Rs1E2FU), 
        .Rs2_E(Rs2E2FU), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE));

    Hazard_Detection_Unit HDU_Imp(
        .Rs1D2HDU(Rs1D2HDU),
        .Rs2D2HDU(Rs2D2HDU),
        .RdE2HDU(RdE2HDU),
        .MemReadE2HDU(MemReadE2HDU),

        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE)
    );

    Control_Hazard_Unit CHU_Imp (
        .reset(reset),
        .rs1(ReadOut1D2CHU),
        .rs2(ReadOut2D2CHU),
        .pc(PCD2CHU),
        .imm(ImmGenOutD2CHU),
        .aluSelect(ALUSelectD2CHU),

        .FlushD(FlushD2CHU), // signal to flush fetch/decode
        .target_pc_valid(PC_Updated_Select), 
        .target_pc(PC_Updated_CHU),
        .Rs1address(Rs1D2CHU),
        .Rs2address(Rs2D2CHU),
        .RdEAddress(RdE2CHU),
        .RdMAddress(RdM2CHU),
        .RdWAddress(RdW2CHU),
        .ALUOutE(ALUOutE2CHU),
        .ALUOutM(ALUOutM2CHU),
        .MuxOutW(MuxOutW2CHU),
        .RegWriteE(RegWriteE2CHU),
        .RegWriteM(RegWriteM2CHU),
        .RegWriteW(RegWriteW2CHU)
    );

    // Always blocks
    MEM_WB_Register MEM_WB_Register_Inst (
        .clk(clk),
        .reset(reset),

        // Inputs from Memory stage
        .JtypeW(JtypeW),
        .RegWriteW(RegWriteW),
        .MemReadW(MemReadW),
        .DataMemOutW(DataMemOutW),
        .ALUOutW(ALUOutW),
        .ALUSelectW(ALUSelectW),
        .WriteAddressW(WriteAddressW),

        // Outputs to WriteBack stage
        .JtypeM2W(JtypeM2W),
        .RegWriteM2W(RegWriteM2W),
        .MemReadM2W(MemReadM2W),
        .DataMemOutM2W(DataMemOutM2W),
        .ALUOutM2W(ALUOutM2W),
        .ALUSelectM2W(ALUSelectM2W),
        .WriteAddressM2W(WriteAddressM2W)
);

    EX_MEM_Register EX_MEM_Register_Inst (
        .clk(clk),
        .reset(reset),

        // Inputs from Execute stage
        .WriteAddressM(WriteAddressM),
        .JtypeM(JtypeM),
        .RegWriteM(RegWriteM),
        .MemReadM(MemReadM),
        .MemWriteM(MemWriteM),
        .BranchM(BranchM),
        .ALUSelectM(ALUSelectM),
        .ALUOutM(ALUOutM),
        .StoreCounterOutM(StoreCounterOutM),
        .PCPlusImmM(PCPlusImmM),

        // Outputs to Memory stage
        .WriteAddressE2M(WriteAddressE2M),
        .JtypeE2M(JtypeE2M),
        .RegWriteE2M(RegWriteE2M),
        .MemReadE2M(MemReadE2M),
        .MemWriteE2M(MemWriteE2M),
        .BranchE2M(BranchE2M),
        .ALUSelectE2M(ALUSelectE2M),
        .ALUOutE2M(ALUOutE2M),
        .StoreCounterOutE2M(StoreCounterOutE2M),
        .PCPlusImmE2M(PCPlusImmE2M)
    );

    ID_EX_Register ID_EX_Register_Inst (
        .clk(clk),
        .reset(reset),

        // Inputs from Decode stage
        .WriteAddressE(WriteAddressE),
        .JtypeE(JtypeE),
        .RegWriteE(RegWriteE),
        .ALUSelectE(ALUSelectE),
        .PCSelectE(PCSelectE),
        .ImmSelectE(ImmSelectE),
        .MemReadE(MemReadE),
        .MemWriteE(MemWriteE),
        .ReadOut1E(ReadOut1E),
        .ReadOut2E(ReadOut2E),
        .ImmGenOutE(ImmGenOutE),
        .PCE(PCE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),

        // Outputs to Execute stage
        .WriteAddressD2E(WriteAddressD2E),
        .JtypeD2E(JtypeD2E),
        .RegWriteD2E(RegWriteD2E),
        .ALUSelectD2E(ALUSelectD2E),
        .PCSelectD2E(PCSelectD2E),
        .ImmSelectD2E(ImmSelectD2E),
        .MemReadD2E(MemReadD2E),
        .MemWriteD2E(MemWriteD2E),
        .ReadOut1D2E(ReadOut1D2E),
        .ReadOut2D2E(ReadOut2D2E),
        .ImmGenOutD2E(ImmGenOutD2E),
        .PCD2E(PCD2E),
        .Rs1D2E(Rs1D2E),
        .Rs2D2E(Rs2D2E)
    );

    IF_ID_Register IF_ID_Register_Inst (
        .StallD_HDU(StallD), // Stall signal from Hazard Detection Unit
        .clk(clk),
        .reset(reset),
        .PCD(PCD),        // PC from Fetch stage
        .InstrD(InstrD),     // Instruction from Fetch stage
        .PCF2D(PCF2D),  // PC to Decode stage
        .InstrF2D(InstrF2D), // Instruction to Decode stage
        .FlushD_CHU(FlushD2CHU) // Flush signal from Control Hazard Unit
    );

    assign probe_output = RegInData;  

endmodule
