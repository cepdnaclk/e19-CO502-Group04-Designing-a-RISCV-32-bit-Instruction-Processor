`timescale 1ns / 1ps

module ImmGen_tb;

    // Inputs
    reg [31:0] instr;

    // Output
    wire [31:0] immOut;

    // Instantiate the ImmGen module
    ImmGen uut (
        .instr(instr),
        .immOut(immOut)
    );

    // Dumping waveforms
    initial begin
        $dumpfile("ImmGen_tb.vcd");
        $dumpvars(0, ImmGen_tb);
    end

    // Test procedure
    initial begin
        // I-type (ADDI x1, x2, 10)
        instr = 32'b000000000010_00010_000_00001_0010011; // imm=2
        #10;

        // I-type (JALR x1, x2, 32)
        instr = 32'b000000001000_00010_000_00001_1100111; // imm=8
        #10;

        // S-type (SW x3, 16(x2))
        instr = 32'b0000000_00011_00010_010_01000_0100011; // imm=16
        #10;

        // B-type (BEQ x1, x2, offset = 12)
        instr = 32'b000000_00010_00001_000_0000_01100_1100011;
        #10;

        // U-type (LUI x1, 0x12345)
        instr = 32'b00010010001101000101_00001_0110111;
        #10;

        // U-type (AUIPC x1, 0xABCD)
        instr = 32'b00000000101010111101_00001_0010111;
        #10;

        // J-type (JAL x1, offset = 2048)
        instr = 32'b000000100000_00000000_0_00000000_1101111;
        #10;

        // Unknown/Invalid opcode (default)
        instr = 32'hFFFFFFFF;
        #10;

        $finish;
    end

endmodule

