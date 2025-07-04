`timescale 1ns/1ps

module tb_Jtype;

    // Testbench signals
    reg  [31:0] pc;
    reg  [31:0] imm;
    reg  [5:0]  aluSelect;
    wire [31:0] next_pc;

    // Instantiate the module under test
    Jtype uut (
        .pc(pc),
        .imm(imm),
        .aluSelect(aluSelect),
        .next_pc(next_pc)
    );

    initial begin
        $display("Time\taluSelect\tpc\t\timm\t\tnext_pc");

        // Test JAL (next_pc = pc + imm)
        pc = 32'd100; imm = 32'd20; aluSelect = 6'b000011; #10;
        $display("%0t\tJAL\t\t%0d\t%0d\t%0d", $time, pc, imm, next_pc);

        // Test JAL with negative immediate
        pc = 32'd200; imm = -32'd40; aluSelect = 6'b000011; #10;
        $display("%0t\tJAL(-imm)\t%0d\t%0d\t%0d", $time, pc, imm, next_pc);

        // Test JALR (next_pc = (pc + imm) & ~1)
        pc = 32'd300; imm = 32'd15; aluSelect = 6'b000100; #10;
        $display("%0t\tJALR\t\t%0d\t%0d\t%0d", $time, pc, imm, next_pc);

        // Test JALR (make sure LSB is cleared)
        pc = 32'd1023; imm = 32'd5; aluSelect = 6'b000100; #10;
        $display("%0t\tJALR(odd sum)\t%0d\t%0d\t%0d", $time, pc, imm, next_pc);

        // Test default case (invalid aluSelect)
        pc = 32'd500; imm = 32'd100; aluSelect = 6'b111111; #10;
        $display("%0t\tDEFAULT\t\t%0d\t%0d\t%0d", $time, pc, imm, next_pc);

        $finish;
    end

endmodule

