`timescale 1ns/1ps

module PCplus4_tb;

    // Declare inputs and outputs
    reg [31:0] fromPC;
    wire [31:0] NextoPC;

    // Instantiate the PCplus4 module
    PCplus4 uut (
        .fromPC(fromPC),
        .NextoPC(NextoPC)
    );

    // Test sequence
    initial begin
        // Displaying the values
        $display("Testing PCplus4 Module");
        $monitor("Time = %0t | fromPC = %h | NextoPC = %h", $time, fromPC, NextoPC);

        // Initialize input
        fromPC = 32'h00000000;

        #10 fromPC = 32'h00000004;
        #10 fromPC = 32'h00000010;
        #10 fromPC = 32'hFFFFFFFC;  // Test with negative address (wrap-around)
        #10 fromPC = 32'h7FFFFFFC;  // Test with a large value
        #10 fromPC = 32'h80000000;  // Test with another large value

        #20 $finish;
    end

endmodule
