`timescale 1ns / 1ps

module Reg_File_tb;

    // Inputs
    reg clk;
    reg reset;
    reg RegWrite;
    reg [4:0] Rs1;
    reg [4:0] Rs2;
    reg [4:0] Rd;
    reg [31:0] Write_data;

    // Outputs
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the Unit Under Test (UUT)
    Reg_File uut (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(Rd),
        .Write_data(Write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Test Sequence
    initial begin
        // Dump waveform
        $dumpfile("Reg_File_tb.vcd");  // VCD waveform file
        $dumpvars(0, Reg_File_tb);     // Dump all variables

        // Initialize Inputs
        clk = 0;
        reset = 1;
        RegWrite = 0;
        Rs1 = 0;
        Rs2 = 0;
        Rd = 0;
        Write_data = 0;

        #10;
        reset = 0;

        // Write to register x5
        Rd = 5;
        Write_data = 32'hDEADBEEF;
        RegWrite = 1;
        #10;
        RegWrite = 0;

        // Read back x5 into Rs1
        Rs1 = 5;
        Rs2 = 0;
        #10;

        // Attempt write to x0 (should be ignored)
        Rd = 0;
        Write_data = 32'hFFFFFFFF;
        RegWrite = 1;
        #10;
        RegWrite = 0;

        // Read x0 and x5 again
        Rs1 = 0;
        Rs2 = 5;
        #10;

        // Write to x10 and x15 sequentially
        Rd = 10; Write_data = 32'hAAAA5555; RegWrite = 1;
        #10;
        Rd = 15; Write_data = 32'h12345678; RegWrite = 1;
        #10;
        RegWrite = 0;

        // Read x10 and x15
        Rs1 = 10; Rs2 = 15;
        #10;

        // Finish simulation
        $finish;
    end

endmodule

