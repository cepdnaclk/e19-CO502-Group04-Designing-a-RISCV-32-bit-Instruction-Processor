`timescale 1ns/1ps

module Adder_tb;

    reg [31:0] in_1, in_2;
    wire [31:0] Sum_out;

    // Instantiate the Adder
    Adder uut (
        .in_1(in_1),
        .in_2(in_2),
        .Sum_out(Sum_out)
    );

    initial begin
        // Dumping waveform
        $dumpfile("adder_tb.vcd");   // VCD file to view in GTKWave
        $dumpvars(0, Adder_tb);      // Dump all variables in testbench

        // Begin test cases
        $display("Time\tin_1\t\tin_2\t\tSum_out");

        // Test 1: 0 + 0
        in_1 = 32'd0;
        in_2 = 32'd0;
        #10;
        $display("%0t\t%0d\t\t%0d\t\t%0d", $time, in_1, in_2, Sum_out);

        // Test 2: 10 + 15
        in_1 = 32'd10;
        in_2 = 32'd15;
        #10;
        $display("%0t\t%0d\t\t%0d\t\t%0d", $time, in_1, in_2, Sum_out);

        // Test 3: -5 + 5 (two's complement)
        in_1 = -32'd5;
        in_2 = 32'd5;
        #10;
        $display("%0t\t%0d\t\t%0d\t\t%0d", $time, in_1, in_2, Sum_out);

        // Test 4: Large unsigned values
        in_1 = 32'hFFFFFF00;
        in_2 = 32'h000000FF;
        #10;
        $display("%0t\t%0h\t%0h\t%0h", $time, in_1, in_2, Sum_out);

        // Test 5: Overflow condition (signed)
        in_1 = 32'h7FFFFFFF;  // Max signed int
        in_2 = 32'd1;
        #10;
        $display("%0t\t%0d\t\t%0d\t\t%0d", $time, in_1, in_2, Sum_out);

        // Finish simulation
        $finish;
    end

endmodule

