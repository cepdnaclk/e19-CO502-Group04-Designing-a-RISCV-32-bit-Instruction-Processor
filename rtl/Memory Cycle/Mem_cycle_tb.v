`timescale 1ns / 1ps

module Mem_cycle_tb;

    // Inputs
    reg clk, reset;
    reg [31:0] PCPlusImmE, ALUOutE, StoreConverterE;
    reg JtypeE, RegWriteE, MemWriteE, MemReadE, BranchE;
    reg [4:0] WriteAddressE;
    reg [5:0] ALUSelectE;

    // Outputs
    wire [31:0] DataMemOutW, ALUOutW, ALUOutF, PCPlusImmF;
    wire JtypeF, JtypeW, RegWriteW, MemReadW, BranchF;
    wire [5:0] ALUSelectW;
    wire [4:0] WriteAddressW;

    // Instantiate the DUT
    Mem_cycle uut (
        .clk(clk),
        .reset(reset),
        .PCPlusImmE(PCPlusImmE),
        .JtypeE(JtypeE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .MemReadE(MemReadE),
        .ALUOutE(ALUOutE),
        .StoreConverterE(StoreConverterE),
        .ALUSelectE(ALUSelectE),
        .WriteAddressE(WriteAddressE),
        .BranchE(BranchE),
        .PCPlusImmF(PCPlusImmF),
        .JtypeF(JtypeF),
        .JtypeW(JtypeW),
        .RegWriteW(RegWriteW),
        .MemReadW(MemReadW),
        .DataMemOutW(DataMemOutW),
        .ALUOutW(ALUOutW),
        .ALUSelectW(ALUSelectW),
        .WriteAddressW(WriteAddressW),
        .BranchF(BranchF),
        .ALUOutF(ALUOutF)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to print all signals
    task print_signals(input [255:0] test_label);
    begin
        $display("----- %s -----", test_label);
        $display("Inputs:");
        $display("  clk = %b | reset = %b", clk, reset);
        $display("  PCPlusImmE = 0x%08h | ALUOutE = 0x%08h", PCPlusImmE, ALUOutE);
        $display("  StoreConverterE = 0x%08h", StoreConverterE);
        $display("  JtypeE = %b | RegWriteE = %b | MemWriteE = %b | MemReadE = %b | BranchE = %b", JtypeE, RegWriteE, MemWriteE, MemReadE, BranchE);
        $display("  ALUSelectE = 0x%02h | WriteAddressE = %d", ALUSelectE, WriteAddressE);

        $display("Outputs:");
        $display("  PCPlusImmF = 0x%08h | ALUOutF = 0x%08h | ALUOutW = 0x%08h", PCPlusImmF, ALUOutF, ALUOutW);
        $display("  DataMemOutW = 0x%08h", DataMemOutW);
        $display("  JtypeF = %b | JtypeW = %b | RegWriteW = %b | MemReadW = %b | BranchF = %b", JtypeF, JtypeW, RegWriteW, MemReadW, BranchF);
        $display("  ALUSelectW = 0x%02h | WriteAddressW = %d", ALUSelectW, WriteAddressW);
        $display("");
    end
    endtask

    initial begin
        $dumpfile("Mem_cycle_tb.vcd");
        $dumpvars(0, Mem_cycle_tb);

        clk = 0; reset = 1;
        PCPlusImmE = 0; ALUOutE = 0; StoreConverterE = 0;
        JtypeE = 0; RegWriteE = 0; MemWriteE = 0; MemReadE = 0; BranchE = 0;
        WriteAddressE = 0; ALUSelectE = 0;

        #10 reset = 0;

        // Test 1: Memory Write
        PCPlusImmE = 32'h1000_0000;
        ALUOutE = 32'h0000_0010;
        StoreConverterE = 32'hDEADBEEF;
        JtypeE = 0; RegWriteE = 1; MemWriteE = 1; MemReadE = 0; BranchE = 0;
        WriteAddressE = 5'd1;
        ALUSelectE = 6'b000001;
        #10 print_signals("Test 1: Memory Write");

        // Test 2: Memory Read
        MemWriteE = 0; MemReadE = 1;
        #10 print_signals("Test 2: Memory Read");

        // Test 3: New Memory Address
        ALUOutE = 32'h0000_0020;
        StoreConverterE = 32'hCAFEBABE;
        MemWriteE = 1; MemReadE = 0;
        WriteAddressE = 5'd2;
        ALUSelectE = 6'b000010;
        PCPlusImmE = 32'h2000_0000;
        JtypeE = 1; BranchE = 1;
        #10 print_signals("Test 3: Write to New Address");

        // Test 4: Read From New Address
        MemWriteE = 0; MemReadE = 1;
        #10 print_signals("Test 4: Read from New Address");

        // Test 5: Max Address
        ALUOutE = 32'hFFFF_FFFC;
        StoreConverterE = 32'h12345678;
        MemWriteE = 1; MemReadE = 0;
        PCPlusImmE = 32'h3333_3333;
        #10 print_signals("Test 5: Write to Max Address");

        MemWriteE = 0; MemReadE = 1;
        #10 print_signals("Test 6: Read from Max Address");

        // Test 7: Zero Address
        ALUOutE = 32'h0000_0000;
        StoreConverterE = 32'hAAAAAAAA;
        MemWriteE = 1; MemReadE = 0;
        #10 print_signals("Test 7: Write to Zero Address");

        MemWriteE = 0; MemReadE = 1;
        #10 print_signals("Test 8: Read from Zero Address");

        // Done
        $display("===== All Tests Completed =====");
        $finish;
    end

endmodule
