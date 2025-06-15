`timescale 1ns/1ps

module Fetch_cycle_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] PCPlusImmM;
    reg [31:0] ALUOutM;
    reg BranchM;
    reg JtypeM;

    // Outputs
    wire [31:0] PCD;
    wire [31:0] InstrD;

    // Instantiate the DUT
    Fetch_cycle uut (
        .clk(clk),
        .reset(reset),
        .PCPlusImmM(PCPlusImmM),
        .ALUOutM(ALUOutM),
        .BranchM(BranchM),
        .JtypeM(JtypeM),
        .PCD(PCD),
        .InstrD(InstrD)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $display("=== Starting fetch_cycle Testbench ===");
        $dumpfile("fetch_cycle.vcd");
        $dumpvars(0, Fetch_cycle_tb);

        // Initialize inputs
        clk = 0;
        reset = 1;
        PCPlusImmM = 32'h0000000c;  // Example branch/jump targets
        ALUOutM = 32'h00000008;
        BranchM = 0;
        JtypeM = 0;

        #10 reset = 0;

        // Fetch 1: Normal PC+4 flow
        #10;

        // Fetch 2: Enable J-type jump (uses ALUOutE)
        BranchM = 1;
        #10;

        // Fetch 3: Enable branch (uses PCPlusImmE)
        BranchM = 1;
        JtypeM = 1;
        #10;

        // Fetch 4: Normal flow again
        BranchM = 0;
        JtypeM = 0;
        #10;

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | PCD: %h | InstrD: %h | JtypeE: %b | BranchE: %b",
                  $time, PCD, InstrD, JtypeM, BranchM);
    end

endmodule
