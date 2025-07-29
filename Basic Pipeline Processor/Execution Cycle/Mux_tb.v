`timescale 1ns/1ps

module Mux_tb;

    reg select;
    reg [31:0] A, B;
    wire [31:0] Mux_out;

    // Instantiate the module
    Mux uut (
        .select(select),
        .A(A),
        .B(B),
        .Mux_out(Mux_out)
    );

    initial begin
        $display("Testing 2-to-1 Mux");
        $monitor("Time = %0t | select = %b | A = %h | B = %h | Mux_out = %h", 
                 $time, select, A, B, Mux_out);

        // Test case 1: select = 0 => output A
        A = 32'hAAAAAAAA;
        B = 32'hBBBBBBBB;
        select = 0;
        #10;

        // Test case 2: select = 1 => output B
        select = 1;
        #10;

        // Test case 3: different values
        A = 32'h12345678;
        B = 32'h87654321;
        select = 0;
        #10;

        select = 1;
        #10;

        $finish;
    end

endmodule
