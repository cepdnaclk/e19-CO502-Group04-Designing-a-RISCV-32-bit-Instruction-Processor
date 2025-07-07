module decode_cycle (
    input         clk,
    input         reset,
    input         FlushE,
    input  [4:0]  WriteAddressW,
    input  [31:0] instructionF,
    input  [31:0] PCF,
    input         RegWriteW,
    input  [31:0] writeDataW,

    output [31:0] PCE,
    output [31:0] ReadOut1E,
    output [31:0] ReadOut2E,
    output [31:0] ImmGenOutE,
    output        JtypeE,
    output        RegWriteE,
    output        PCSelectE,
    output        ImmSelectE,
    output        MemReadE,
    output        MemWriteE,
    output [5:0]  ALUSelectE,
    output [4:0]  WriteAddressE,
    output [4:0]  Rs1E,
    output [4:0]  Rs2E,
    output [4:0]  Rs1D2HDU,
    output [4:0]  Rs2D2HDU
);

    // Internal wires for raw control signals from Control Unit
    wire JtypeD, RegWriteD, PCSelectD, ImmSelectD, MemReadD, MemWriteD;
    wire [5:0] ALUSelectD;

    // Instantiate Control Unit
    ControlUnit ControlUnitD (
        .instruction(instructionF),
        .aluSelect(ALUSelectD),
        .MemWrite(MemWriteD),
        .MemRead(MemReadD),
        .ImmSelect(ImmSelectD),
        .PCSelect(PCSelectD),
        .regWrite(RegWriteD),
        .Jtype(JtypeD)
    );

    // Control masking with FlushE signal
    Masking_Mux_CU Masking_Mux_CU_Imp (
        .FlushE(FlushE),
        .RegWrite(RegWriteD),
        .MemRead(MemReadD),
        .MemWrite(MemWriteD),
        .ImmSelect(ImmSelectD),
        .PCSelect(PCSelectD),
        .Jtype(JtypeD),
        .ALUSelect(ALUSelectD),
        .RegWriteMasked(RegWriteE),
        .MemReadMasked(MemReadE),
        .MemWriteMasked(MemWriteE),
        .ImmSelectMasked(ImmSelectE),
        .PCSelectMasked(PCSelectE),
        .JtypeMasked(JtypeE),
        .ALUSelectMasked(ALUSelectE)
    );

    // Register addresses
    assign PCE           = PCF;
    assign WriteAddressE = instructionF[11:7];
    assign Rs1E          = instructionF[19:15];
    assign Rs2E          = instructionF[24:20];

    // Hazard detection connections
    assign Rs1D2HDU      = instructionF[19:15];
    assign Rs2D2HDU      = instructionF[24:20];

    // Register File
    Reg_File Reg_File_D (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWriteW),
        .Rs1(instructionF[19:15]),
        .Rs2(instructionF[24:20]),
        .Rd(WriteAddressW),
        .Write_data(writeDataW),
        .read_data1(ReadOut1E),
        .read_data2(ReadOut2E)
    );

    // Immediate Generator
    ImmGen ImmGen_D (
        .instr(instructionF),
        .immOut(ImmGenOutE)
    );

endmodule
