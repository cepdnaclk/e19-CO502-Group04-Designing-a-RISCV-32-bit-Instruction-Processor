`timescale 1ns/1ps

module tb_Instruction_Mem;

    reg clk;
    reg reset;
    reg [31:0] read_address;
    wire [31:0] instruction_out;

    // Instantiate the DUT (Design Under Test)
    Instruction_Mem uut (
        .clk(clk),
        .reset(reset),
        .read_address(read_address),
        .instruction_out(instruction_out)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $display("=== Starting Instruction Memory Testbench ===");
        $dumpfile("Instruction_Mem.vcd");     // For GTKWave viewing
        $dumpvars(0, tb_Instruction_Mem);

        clk = 0;
        reset = 1;
        read_address = 0;

        #10 reset = 0;

        // Apply a series of read addresses
        #10 read_address = 32'd0;   // Address 0 → word 0
        #10 read_address = 32'd4;   // Address 4 → word 1
        #10 read_address = 32'd8;   // Address 8 → word 2
        #10 read_address = 32'd12;  // Address 12 → word 3
        #10 read_address = 32'd16;  // Address 16 → word 4

        #10 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | Addr: %0d | Instr: %h", $time, read_address, instruction_out);
    end

endmodule
