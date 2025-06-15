module top_cpu(input clk, input reset);

    // Internal registers
    reg [31:0] PCF2D, InstrF2D, ReadOut1D2E, ReadOut2D2E, ImmGenOutD2E, PCD2E;
    reg [31:0] ALUOutE2M, StoreCounterOutE2M, PCPlusImmE2M;
    reg [31:0] DataMemOutM2W, ALUOutM2W;

    reg JtypeD2E, RegWriteD2E, PCSelectD2E, ImmSelectD2E, MemReadD2E, MemWriteD2E;
    reg JtypeE2M, RegWriteE2M, MemReadE2M, MemWriteE2M, BranchE2M;
    reg JtypeM2W, RegWriteM2W, MemReadM2W;

    reg [5:0] ALUSelectD2E, ALUSelectE2M, ALUSelectM2W;
    reg [4:0] WriteAddressD2E, WriteAddressE2M, WriteAddressM2W;

    // Internal wires
    wire [31:0] PCD, InstrD, ReadOut1E, ReadOut2E, ImmGenOutE, PCE;
    wire [31:0] ALUOutM, StoreCounterOutM, PCPlusImmM, PCPlusImm;
    wire [31:0] ALUOut, DataMemOutW, ALUOutW, RegInData;

    wire JtypeE, RegWriteE, PCSelectE, ImmSelectE, MemReadE, MemWriteE;
    wire JtypeM, RegWriteM, MemReadM, MemWriteM, BranchM;
    wire Jtype, Branch, JtypeW, RegWriteW, MemReadW, RegWrite;

    wire [5:0] ALUSelectE, ALUSelectM, ALUSelectW;
    wire [4:0] WriteAddressE, WriteAddressM, WriteAddress, WriteAddressW;

    // Module instantiations
    Fetch_cycle fetch_cycle_Imp (
        .clk(clk), 
        .reset(reset), 
        .PCD(PCD), 
        .InstrD(InstrD),
        .PCPlusImmM(PCPlusImm), 
        .ALUOutM(ALUOut), 
        .BranchM(Branch), 
        .JtypeM(Jtype)
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
        .writeDataW(RegInData)
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
        .JtypeM(JtypeM), 
        .RegWriteM(RegWriteM), 
        .MemReadM(MemReadM), 
        .MemWriteM(MemWriteM), 
        .BranchM(BranchM), 
        .ALUOutM(ALUOutM), 
        .ALUSelectM(ALUSelectM), 
        .StoreCounterOutM(StoreCounterOutM),
        .PCPlusImmM(PCPlusImmM)
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
        .ALUOutF(ALUOut)
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
        .WriteAddressD(WriteAddress)
    );

    // Always blocks
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            JtypeM2W <= 0;
            RegWriteM2W <= 0;
            MemReadM2W <= 0;
            DataMemOutM2W <= 0;
            ALUOutM2W <= 0;
            ALUSelectM2W <= 0;
            WriteAddressM2W <= 0;
        end else begin
            JtypeM2W <= JtypeW;
            RegWriteM2W <= RegWriteW;
            MemReadM2W <= MemReadW;
            DataMemOutM2W <= DataMemOutW;
            ALUOutM2W <= ALUOutW;
            ALUSelectM2W <= ALUSelectW;
            WriteAddressM2W <= WriteAddressW;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WriteAddressE2M <= 0;
            JtypeE2M <= 0;
            RegWriteE2M <= 0;
            MemReadE2M <= 0;
            MemWriteE2M <= 0;
            BranchE2M <= 0;
            ALUSelectE2M <= 0;
            ALUOutE2M <= 0;
            StoreCounterOutE2M <= 0;
            PCPlusImmE2M <= 0;
        end else begin
            WriteAddressE2M <= WriteAddressM;
            JtypeE2M <= JtypeM;
            RegWriteE2M <= RegWriteM;
            MemReadE2M <= MemReadM;
            MemWriteE2M <= MemWriteM;
            BranchE2M <= BranchM;
            ALUSelectE2M <= ALUSelectM;
            ALUOutE2M <= ALUOutM;
            StoreCounterOutE2M <= StoreCounterOutM;
            PCPlusImmE2M <= PCPlusImmM;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WriteAddressD2E <= 0;
            JtypeD2E <= 0;
            RegWriteD2E <= 0;
            ALUSelectD2E <= 0;
            PCSelectD2E <= 0;
            ImmSelectD2E <= 0;
            MemReadD2E <= 0;
            MemWriteD2E <= 0;
            ReadOut1D2E <= 0;
            ReadOut2D2E <= 0;
            ImmGenOutD2E <= 0;
            PCD2E <= 0;
        end else begin
            WriteAddressD2E <= WriteAddressE;
            JtypeD2E <= JtypeE;
            RegWriteD2E <= RegWriteE;
            ALUSelectD2E <= ALUSelectE;
            PCSelectD2E <= PCSelectE;
            ImmSelectD2E <= ImmSelectE;
            MemReadD2E <= MemReadE;
            MemWriteD2E <= MemWriteE;
            ReadOut1D2E <= ReadOut1E;
            ReadOut2D2E <= ReadOut2E;
            ImmGenOutD2E <= ImmGenOutE;
            PCD2E <= PCE;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PCF2D <= 0;
            InstrF2D <= 0;
        end else begin
            PCF2D <= PCD;
            InstrF2D <= InstrD;
        end
    end

endmodule
