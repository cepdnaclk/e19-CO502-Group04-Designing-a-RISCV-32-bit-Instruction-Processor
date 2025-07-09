`timescale 1ns/1ps

module Utype_tb;

    // Testbench signals
    reg [31:0] pc;
    reg [31:0] imm_u;
    reg [5:0]  aluSelect;
    wire [31:0] result;

    // Instantiate the DUT (Device Under Test)
    Utype dut (
        .pc(pc),
        .imm_u(imm_u),
        .aluSelect(aluSelect),
        .result(result)
    );

    // Task to display the results
    task show;
        begin
            $display("time=%0t  aluSelect=%b  pc=%h  imm_u=%h  -> result=%h",
                     $time, aluSelect, pc, imm_u, result);
        end
    endtask

    initial begin
        $display("\n=== Utype Testbench ===");

        // Test Case 1: AUIPC (aluSelect = 000010)
        pc = 32'h0000_1000;
        imm_u = 32'h0000_0010;
        aluSelect = 6'b000010;   // AUIPC
        #5; show();              // expect 0x00001010 (pc + imm_u)

        // Test Case 2: LUI (aluSelect = 000001)
        aluSelect = 6'b000001;   // LUI
        #5; show();              // expect 0x00000010 (imm_u)

        // Test Case 3: Default (aluSelect not recognized)
        aluSelect = 6'b111111;   // Invalid aluSelect
        #5; show();              // expect 0x00000000 (default case)

        $display("\nTestbench complete.");
        $finish;
    end

endmodule
