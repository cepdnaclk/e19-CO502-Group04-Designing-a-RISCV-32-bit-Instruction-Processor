`timescale 1ns/1ps

module tb_Program_Counter;

    // Testbench Signals
    reg clk;
    reg reset;
    reg [31:0] PC_in;
    wire [31:0] PC_out;

    // Instantiate the DUT (Design Under Test)
    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Clock Generation: 10 ns clock period
    always #5 clk = ~clk;

    // Test Procedure
    initial begin
        // VCD file for waveform viewing
        $dumpfile("Program_Counter.vcd");
        $dumpvars(0, tb_Program_Counter);

        // Initial values
        clk = 0;
        reset = 0;
        PC_in = 0;

        // Apply reset
        #2 reset = 1;
        #10 reset = 0;

        // Apply new PC values
        #10 PC_in = 32'h00000004;
        #10 PC_in = 32'h00000008;
        #10 PC_in = 32'h0000000C;

        // Apply reset again
        #10 reset = 1;
        #10 reset = 0;

        // Change PC again
        #10 PC_in = 32'h00000010;
        #10 PC_in = 32'h00000014;

        // Finish simulation
        #20 $finish;
    end

endmodule

