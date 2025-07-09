module decode_cycle(clk, reset, WriteAddressE, WriteAddressW, instructionF, PCF, RegWriteW, writeDataW, JtypeE, RegWriteE, ALUSelectE, PCSelectE, ImmSelectE, MemReadE, MemWriteE, ReadOut1E, ReadOut2E, ImmGenOutE, PCE);

    input clk, reset, RegWriteW;
    input [31:0] instructionF, PCF, writeDataW;
    input [4:0] WriteAddressW;
    output [31:0] PCE, ReadOut1E, ReadOut2E, ImmGenOutE;
    output JtypeE, RegWriteE, PCSelectE, ImmSelectE, MemReadE, MemWriteE;
    output [5:0] ALUSelectE;
    output [4:0] WriteAddressE;

    ControlUnit ControlUnitD(
    .instruction(instructionF),
    .aluSelect(ALUSelectE),   // Fixed width to 6 bits
    .MemWrite(MemWriteE),
    .MemRead(MemReadE),
    .ImmSelect(ImmSelectE),
    .PCSelect(PCSelectE),
    .regWrite(RegWriteE),
    .Jtype(JtypeE)
    );

    assign PCE = PCF;
    assign WriteAddressE = instructionF[11:7];

    Reg_File Reg_File_D(
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

    ImmGen ImmGen_D(
    .instr(instructionF),
    .immOut(ImmGenOutE)
    );

endmodule