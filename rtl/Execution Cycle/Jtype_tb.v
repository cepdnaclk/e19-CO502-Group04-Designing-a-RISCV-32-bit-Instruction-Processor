`timescale 1ns / 1ps

module Jtype_tb;

    // Testbench signals
    reg  [31:0] rs1;
    reg  [31:0] imm;
    reg  [5:0]  aluSelect;
    wire [31:0] next_pc;

    // Instantiate the Jtype module
    Jtype uut (
        .rs1(rs1),
        .imm(imm),
        .aluSelect(aluSelect),
        .next_pc(next_pc)
    );

    initial begin
        $display("Starting Jtype testbench...");
        
        // Test JAL: aluSelect = 6'b000011
        rs1 = 32'd0;  // unused for JAL
        imm = 32'd100;
        aluSelect = 6'b000011;
        #10;
        $display("JAL -> next_pc = %0d (expected 100)", next_pc);

        // Test JALR: aluSelect = 6'b000100
        rs1 = 32'd200;
        imm = 32'd12;
        aluSelect = 6'b000100;
        #10;
        $display("JALR -> next_pc = %0d (expected 212 & ~1 = 212)", next_pc);

        // Test Default
        rs1 = 32'd0;
        imm = 32'd0;
        aluSelect = 6'b111111;
        #10;
        $display("Default -> next_pc = %0d (expected 0)", next_pc);

        $finish;
    end

endmodule
