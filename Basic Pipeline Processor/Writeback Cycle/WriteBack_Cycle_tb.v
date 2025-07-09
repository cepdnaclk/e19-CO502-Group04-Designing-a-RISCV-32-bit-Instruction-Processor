`timescale 1ns / 1ps

module execution_cycle_tb;

    // Inputs
    reg [31:0] DataMemOutM, ALUOutM;
    reg [5:0] ALUSelectM;
    reg [4:0] WriteAddressM;
    reg RegWriteM, JtypeM, MemReadM;

    // Outputs
    wire [31:0] RegInDataD;
    wire [4:0] WriteAddressD;
    wire RegWriteD;

    // Instantiate the DUT
    writeBack_cycle uut (
        .RegWriteM(RegWriteM),
        .JtypeM(JtypeM),
        .MemReadM(MemReadM),
        .DataMemOutM(DataMemOutM),
        .ALUOutM(ALUOutM),
        .ALUSelectM(ALUSelectM),
        .WriteAddressM(WriteAddressM),
        .RegInDataD(RegInDataD),
        .WriteAddressD(WriteAddressD),
        .RegWriteD(RegWriteD)
    );

    // Task to print all signals
    task print_signals(input [255:0] label);
    begin
        $display("---- %s ----", label);
        $display("Inputs:");
        $display("  MemReadM = %b | JtypeM = %b | RegWriteM = %b", MemReadM, JtypeM, RegWriteM);
        $display("  DataMemOutM = 0x%08h | ALUOutM = 0x%08h", DataMemOutM, ALUOutM);
        $display("  ALUSelectM = 0x%02h | WriteAddressM = %d", ALUSelectM, WriteAddressM);
        $display("Outputs:");
        $display("  RegInDataD = 0x%08h", RegInDataD);
        $display("  WriteAddressD = %d | RegWriteD = %b", WriteAddressD, RegWriteD);
        $display("");
    end
    endtask

    initial begin
        $dumpfile("execution_cycle_tb.vcd");
        $dumpvars(0, execution_cycle_tb);

        // Default values
        DataMemOutM = 0; ALUOutM = 0; ALUSelectM = 0;
        WriteAddressM = 0;
        RegWriteM = 0; JtypeM = 0; MemReadM = 0;

        #10;

        // Test 1: ALU result, not MemRead, not J-type
        ALUOutM = 32'h12345678;
        ALUSelectM = 6'b000001;
        RegWriteM = 1;
        MemReadM = 0;
        JtypeM = 0;
        WriteAddressM = 5'd5;
        #10 print_signals("Test 1: ALU output only");

        // Test 2: Load from memory
        DataMemOutM = 32'hABCD1234;
        MemReadM = 1;
        JtypeM = 0;
        ALUSelectM = 6'b000010;
        #10 print_signals("Test 2: MemRead with LoadConverter");

        // Test 3: J-type instruction
        JtypeM = 1;
        #10 print_signals("Test 3: J-type adds 4");

        // Test 4: RegWrite = 0
        RegWriteM = 0;
        #10 print_signals("Test 4: RegWrite disabled");

        // Test 5: New ALUSelect for LoadConverter variation
        ALUSelectM = 6'b111111;
        RegWriteM = 1;
        MemReadM = 1;
        JtypeM = 0;
        DataMemOutM = 32'hDEADBEEF;
        #10 print_signals("Test 5: Different ALUSelect");

        // Test 6: WriteAddress edge case
        WriteAddressM = 5'd31;
        #10 print_signals("Test 6: Max Write Address");

        // Test 7: All inputs zero
        DataMemOutM = 0; ALUOutM = 0;
        MemReadM = 0; JtypeM = 0; RegWriteM = 0;
        WriteAddressM = 0;
        ALUSelectM = 0;
        #10 print_signals("Test 7: All Zeros");

        // Done
        $display("===== All Tests Completed =====");
        $finish;
    end

endmodule
