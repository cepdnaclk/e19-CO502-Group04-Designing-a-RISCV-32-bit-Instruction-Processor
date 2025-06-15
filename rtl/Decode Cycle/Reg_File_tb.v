`timescale 1ns/1ps

module Reg_File_tb;

    reg clk;
    reg reset;
    reg RegWrite;
    reg [4:0] Rs1, Rs2, Rd;
    reg [31:0] Write_data;
    wire [31:0] read_data1, read_data2;

    // Instantiate the register file
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

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Task to write to a register
    task write_reg(input [4:0] rd, input [31:0] data);
    begin
        @(negedge clk);
        RegWrite = 1;
        Rd = rd;
        Write_data = data;
        @(negedge clk);
        RegWrite = 0;
        Rd = 0;
        Write_data = 0;
    end
    endtask

    // Task to read from two registers
    task read_regs(input [4:0] rs1, input [4:0] rs2);
    begin
        Rs1 = rs1;
        Rs2 = rs2;
        @(negedge clk);
        $display("Read: rs1=%0d -> %h, rs2=%0d -> %h", rs1, read_data1, rs2, read_data2);
    end
    endtask

    initial begin
        // Initialize signals
        RegWrite = 0;
        Rd = 0;
        Write_data = 0;
        Rs1 = 0;
        Rs2 = 0;

        // Reset the register file
        reset = 1;
        @(negedge clk);
        reset = 0;
        $display("After reset:");
        read_regs(0, 1);

        // Write to registers 1, 2, 3
        write_reg(1, 32'hA5A5A5A5);
        write_reg(2, 32'h5A5A5A5A);
        write_reg(3, 32'hDEADBEEF);

        // Read back written registers
        $display("After writing to 1, 2, 3:");
        read_regs(1, 2);
        read_regs(3, 0);

        // Attempt to write to register 0 (should be ignored)
        write_reg(0, 32'hFFFFFFFF);
        $display("After attempting to write to x0:");
        read_regs(0, 1);

        // Attempt to write with RegWrite deasserted (should not change reg 2)
        @(negedge clk);
        RegWrite = 0;
        Rd = 2;
        Write_data = 32'h12345678;
        @(negedge clk);
        $display("After attempting to write to reg 2 with RegWrite=0:");
        read_regs(2, 0);

        // Overwrite register 3
        write_reg(3, 32'hCAFEBABE);
        $display("After overwriting reg 3:");
        read_regs(3, 0);

        $display("Testbench completed.");
        $finish;
    end

endmodule
