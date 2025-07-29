module Mem_cycle(ALUOut2CHU, RdEAddressCHU, RegWrite2CHU, clk, reset, PCPlusImmE, JtypeE, RegWriteE, MemWriteE, MemReadE, ALUOutE, StoreConverterE, ALUSelectE, WriteAddressE, BranchE, PCPlusImmF, JtypeF, JtypeW, RegWriteW, MemReadW, DataMemOutW, ALUOutW, ALUSelectW, WriteAddressW, BranchF, ALUOutF, RegWrite2FU, ALUOut2E, WriteAddress2FU);

    input clk, reset, JtypeE, RegWriteE, MemWriteE, MemReadE, BranchE;
    input [31:0] PCPlusImmE, ALUOutE, StoreConverterE;
    input [4:0] WriteAddressE;
    input [5:0] ALUSelectE;
    output [31:0] DataMemOutW, ALUOutW, ALUOutF, PCPlusImmF, ALUOut2E;
    output JtypeF, JtypeW, RegWriteW, MemReadW, BranchF, RegWrite2FU;
    output [5:0] ALUSelectW;
    output [4:0] WriteAddressW, WriteAddress2FU;
    output [31:0] ALUOut2CHU;
    output [4:0] RdEAddressCHU;
    output RegWrite2CHU;

    DataMemory DataMemoryMem(
        .clk(clk), 
        .reset(reset), 
        .MemWrite(MemWriteE), 
        .MemRead(MemReadE), 
        .read_address(ALUOutE), 
        .Write_data(StoreConverterE), 
        .MemData_out(DataMemOutW)
    );

    assign PCPlusImmF = PCPlusImmE;
    assign JtypeF = JtypeE;
    assign JtypeW = JtypeE;
    assign RegWriteW = RegWriteE;
    assign ALUOutF = ALUOutE;
    assign ALUOutW = ALUOutE;
    assign ALUSelectW = ALUSelectE;
    assign WriteAddressW = WriteAddressE;
    assign BranchF = BranchE;
    assign MemReadW = MemReadE;
    assign WriteAddress2FU = WriteAddressE;
    assign ALUOut2E = ALUOutE;
    assign RegWrite2FU = RegWriteE;
    assign ALUOut2CHU = ALUOutE; // ALU output for CHU
    assign RdEAddressCHU = WriteAddressE; // Write address for CHU
    assign RegWrite2CHU = RegWriteE; // Register write signal for CHU

endmodule