`timescale 1ns / 1ps

module ControlUnit_tb();

    reg [31:0] instruction;
    wire [5:0] aluSelect;
    wire MemWrite, MemRead, ImmSelect, PCSelect, regWrite, Jtype;

    // Instantiate the Control Unit
    ControlUnit uut (
        .instruction(instruction),
        .aluSelect(aluSelect),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ImmSelect(ImmSelect),
        .PCSelect(PCSelect),
        .regWrite(regWrite),
        .Jtype(Jtype)
    );

    initial begin
        // Setup waveform dump
        $dumpfile("ControlUnit_tb.vcd");
        $dumpvars(0, ControlUnit_tb);

        // Initialize input
        instruction = 32'b0;

        // Wait some time before starting
        #10;

        // Test JAL instruction (opcode 1101111)
        instruction = {20'd0, 12'b0000001101111}; // Only opcode bits matter here
        #10;

        // Test JALR instruction (opcode 1100111)
        instruction = {20'd0, 12'b0000001100111};
        #10;

        // Test Branch instructions (opcode 1100011) with different funct3 values
        // BEQ (funct3=000)
        instruction = {20'd0, 3'b000, 4'b0000, 7'b1100011}; 
        #10;
        // BNE (funct3=001)
        instruction = {20'd0, 3'b001, 4'b0000, 7'b1100011};
        #10;
        // BLT (funct3=100)
        instruction = {20'd0, 3'b100, 4'b0000, 7'b1100011};
        #10;

        // Test Load instructions (opcode 0000011)
        // LB (funct3=000)
        instruction = {20'd0, 3'b000, 4'b0000, 7'b0000011};
        #10;
        // LW (funct3=010)
        instruction = {20'd0, 3'b010, 4'b0000, 7'b0000011};
        #10;

        // Test Store instructions (opcode 0100011)
        // SB (funct3=000)
        instruction = {20'd0, 3'b000, 4'b0000, 7'b0100011};
        #10;
        // SW (funct3=010)
        instruction = {20'd0, 3'b010, 4'b0000, 7'b0100011};
        #10;

        // Test I-type ALU (opcode 0010011), ADDI (funct3=000)
        instruction = 32'b000000000000_00000_000_00000_0010011; 
        #10;

        // Test R-type ALU (opcode 0110011), ADD (funct7=0000000, funct3=000)
        instruction = 32'b0000000_00000_00000_000_00000_0110011;
        #10;

        // Test R-type MUL (opcode 0110011), MUL (funct7=0000001, funct3=000)
        instruction = 32'b0000001_00000_00000_000_00000_0110011;
        #10;

        // Test AUIPC (opcode 0010111)
        instruction = {20'd0, 7'b0010111};
        #10;

        // Test LUI (opcode 0110111)
        instruction = {20'd0, 7'b0110111};
        #10;

        // Test FENCE (opcode 0001111)
        instruction = {25'd0, 7'b0001111};
        #10;

        // Test ECALL/EBREAK (opcode 1110011)
        instruction = {25'd0, 7'b1110011};
        #10;

        // Finish simulation
        $finish;
    end

endmodule

