`timescale 1ns/1ps

module Program_Counter_tb;

    reg clk, reset;
    reg [31:0] PC_in;
    wire [31:0] PC_out;

    // Instantiate the Program Counter module
    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Generate clock with period of 10 ns
    always #5 clk = ~clk;

    initial begin
        $display("Testing Program_Counter Module");
        $monitor("Time = %0t | reset = %b | PC_in = %h | PC_out = %h", 
                  $time, reset, PC_in, PC_out);

        // Initialize signals
        clk = 0;
        reset = 1;
        PC_in = 32'h00000000;

        #10;
        reset = 0;

        #10 PC_in = 32'h00000004;
        #10 PC_in = 32'h00000008;
        #10 PC_in = 32'h0000000C;

        // Apply reset again
        #10 reset = 1;
        #10 reset = 0;

        #10 PC_in = 32'h00000010;
        #10 PC_in = 32'h00000014;

        #20 $finish;
    end

endmodule
