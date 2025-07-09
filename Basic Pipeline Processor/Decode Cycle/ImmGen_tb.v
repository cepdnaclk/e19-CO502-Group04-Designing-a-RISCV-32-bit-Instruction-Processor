`timescale 1ns/1ps

module ImmGen_tb;

    reg [31:0] instr;
    wire [31:0] immOut;

    ImmGen uut (
        .instr(instr),
        .immOut(immOut)
    );

    initial begin
        $display("Testing ImmGen Module");

        // I-type: ADDI x1, x1, 1
        instr = 32'h00108093; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("I-type Immediate: %08x", immOut);

        // S-type: SW x2, 0(x1)
        instr = 32'h0020a123; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("S-type Immediate: %08x", immOut);

        // B-type: BEQ x1, x1, 0x800
        instr = 32'h001080e3; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("B-type Immediate: %08x", immOut);

        // U-type: LUI x1, 0x00008
        instr = 32'h000080b7; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("U-type Immediate (LUI): %08x", immOut);

        // U-type: AUIPC x1, 0x00108
        instr = 32'h00108097; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("U-type Immediate (AUIPC): %08x", immOut);

        // J-type: JAL x1, 0x000001
        instr = 32'h001000ef; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("J-type Immediate (JAL): %08x", immOut);

        // I-type: JALR x1, x1, 1
        instr = 32'h001080e7; #10;
        $display("At time %t, instr = %08x, immOut = %08x", $time, instr, immOut);
        $display("I-type Immediate (JALR): %08x", immOut);

        $finish;
    end

endmodule
