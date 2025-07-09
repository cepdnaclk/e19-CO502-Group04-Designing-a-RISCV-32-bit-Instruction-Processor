`timescale 1ns / 1ps

module Adder_tb;

    // Testbench signals
    reg  [31:0] in_1;
    reg  [31:0] in_2;
    wire [31:0] Sum_out;

    // Instantiate the Adder module
    Adder uut (
        .in_1(in_1),
        .in_2(in_2),
        .Sum_out(Sum_out)
    );

    // Test procedure
    initial begin
        // Setup waveform dumping
        $dumpfile("Adder_Wave.vcd");      // VCD file name
        $dumpvars(0, Adder_tb);           // Dump all signals in Adder_tb and its instances

        $display("Time\tin_1\t\tin_2\t\tSum_out");
        $monitor("%0dns\t%h\t%h\t%h", $time, in_1, in_2, Sum_out);

        // Test 1: 0 + 0
        in_1 = 32'h00000000;
        in_2 = 32'h00000000;
        #10;

        // Test 2: 1 + 1
        in_1 = 32'h00000001;
        in_2 = 32'h00000001;
        #10;

        // Test 3: 10 + 20
        in_1 = 32'd10;
        in_2 = 32'd20;
        #10;

        // Test 4: max + 1 (overflow test)
        in_1 = 32'hFFFFFFFF;
        in_2 = 32'h00000001;
        #10;

        // Test 5: random values
        in_1 = 32'h12345678;
        in_2 = 32'h11111111;
        #10;

        // Finish simulation
        $finish;
    end

endmodule
