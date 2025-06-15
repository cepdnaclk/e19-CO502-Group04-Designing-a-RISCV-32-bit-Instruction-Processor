`timescale 1ns / 1ps

module Btype_tb;

    reg [6:0] aluSelect;
    reg [31:0] rs1, rs2;
    wire branch_taken;

    // Instantiate the module under test
    Btype uut (
        .aluSelect(aluSelect),
        .rs1(rs1),
        .rs2(rs2),
        .branch_taken(branch_taken)
    );

    initial begin
        // Monitor outputs
        $monitor("Time=%0t | aluSelect=%b | rs1=%d | rs2=%d | branch_taken=%b", 
                 $time, aluSelect, rs1, rs2, branch_taken);

        // Test BEQ (rs1 == rs2)
        aluSelect = 6'b0001010; rs1 = 32'd10; rs2 = 32'd10; #10;

        // Test BNE (rs1 != rs2)
        aluSelect = 6'b0001100; rs1 = 32'd10; rs2 = 32'd20; #10;

        // Test BLT (rs1 < rs2, signed)
        aluSelect = 6'b0001110; rs1 = -5; rs2 = 10; #10;

        // Test BGE (rs1 >= rs2, signed)
        aluSelect = 6'b0010000; rs1 = -5; rs2 = -10; #10;

        // Test BLTU (rs1 < rs2, unsigned)
        aluSelect = 6'b0010010; rs1 = 32'h00000001; rs2 = 32'hFFFFFFFE; #10;

        // Test BGEU (rs1 >= rs2, unsigned)
        aluSelect = 6'b0010100; rs1 = 32'hFFFFFFFE; rs2 = 32'h00000001; #10;

        // Test default
        aluSelect = 6'b0111111; rs1 = 32'd0; rs2 = 32'd0; #10;

        $finish;
    end

endmodule
