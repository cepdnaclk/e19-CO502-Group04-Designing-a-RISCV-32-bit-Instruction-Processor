`timescale 1ns / 1ps

module ShiftLeft1_tb;

    // Inputs
    reg [31:0] in;

    // Outputs
    wire [31:0] out;

    // Instantiate the Unit Under Test (UUT)
    ShiftLeft1 uut (
        .in(in),
        .out(out)
    );

    initial begin
        // Display header
        $display("Time\tin\t\t\t\tout");

        // Monitor changes
        $monitor("%0dns\t%b\t%b", $time, in, out);

        // Test cases
        in = 32'b00000000_00000000_00000000_00000001; // 1 -> 2
        #10;

        in = 32'b00000000_00000000_00000000_10000000; // 128 -> 256
        #10;

        in = 32'hFFFFFFFF; // all 1s -> shift left by 1
        #10;

        in = 32'h80000000; // MSB is 1 -> becomes 0 after shift
        #10;

        in = 32'b0; // 0 -> 0
        #10;

        $finish;
    end

endmodule
