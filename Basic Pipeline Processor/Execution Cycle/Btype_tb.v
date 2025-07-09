`timescale 1ns/1ps

module tb_Btype;
    reg [5:0] aluSelect;
    reg [31:0] rs1;
    reg [31:0] rs2;
    wire branch_taken;
    wire [31:0] result;

    // Instantiate the module under test
    Btype uut (
        .aluSelect(aluSelect),
        .rs1(rs1),
        .rs2(rs2),
        .branch_taken(branch_taken),
        .result(result)
    );

    initial begin
        $display("Time\taluSelect\t rs1\t\t rs2\t\tbranch_taken");

        // BEQ: rs1 == rs2
        aluSelect = 6'b000101; rs1 = 32'd10; rs2 = 32'd10; #10;
        $display("%0t\tBEQ\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // BNE: rs1 != rs2
        aluSelect = 6'b000110; rs1 = 32'd10; rs2 = 32'd20; #10;
        $display("%0t\tBNE\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // BLT: signed rs1 < rs2
        aluSelect = 6'b000111; rs1 = -10; rs2 = 5; #10;
        $display("%0t\tBLT\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // BGE: signed rs1 >= rs2
        aluSelect = 6'b001000; rs1 = -5; rs2 = -10; #10;
        $display("%0t\tBGE\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // BLTU: unsigned rs1 < rs2
        aluSelect = 6'b001001; rs1 = 32'h00000001; rs2 = 32'hFFFFFFFF; #10;
        $display("%0t\tBLTU\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // BGEU: unsigned rs1 >= rs2
        aluSelect = 6'b001010; rs1 = 32'hFFFFFFFF; rs2 = 32'h00000001; #10;
        $display("%0t\tBGEU\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // Unconditional branch 1
        aluSelect = 6'b000011; rs1 = 32'd0; rs2 = 32'd0; #10;
        $display("%0t\tJAL\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // Unconditional branch 2
        aluSelect = 6'b000100; rs1 = 32'd0; rs2 = 32'd0; #10;
        $display("%0t\tJALR\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        // Invalid opcode
        aluSelect = 6'b111111; rs1 = 32'd10; rs2 = 32'd10; #10;
        $display("%0t\tDEFAULT\t\t %0d\t %0d\t %b", $time, rs1, rs2, branch_taken);

        $finish;
    end
endmodule
