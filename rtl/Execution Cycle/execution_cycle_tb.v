`timescale 1ns / 1ps

module execution_cycle_tb;

    // Inputs
    reg [31:0] PCD, ImmGenOutD, RegOut1D, RegOut2D;
    reg [5:0] ALUSelectD;
    reg [4:0] WriteAddressD;  // NEW
    reg JtypeD, RegWriteD, MemReadD, MemWriteD, ImmSelectD, PCSelectD;

    // Outputs
    wire [31:0] PCPlusImmF, ALUOutM, StoreCounterOutM;
    wire [5:0] ALUSelectM;
    wire [4:0] WriteAddressM; // NEW
    wire JtypeM, RegWriteM, MemReadM, MemWriteM, BranchF;

    // Instantiate the UUT
    execution_cycle uut (
        .PCD(PCD),
        .ImmGenOutD(ImmGenOutD),
        .RegOut1D(RegOut1D),
        .RegOut2D(RegOut2D),
        .WriteAddressD(WriteAddressD),    // CONNECTED
        .JtypeD(JtypeD),
        .RegWriteD(RegWriteD),
        .MemReadD(MemReadD),
        .MemWriteD(MemWriteD),
        .ImmSelectD(ImmSelectD),
        .PCSelectD(PCSelectD),
        .ALUSelectD(ALUSelectD),
        .WriteAddressM(WriteAddressM),    // CONNECTED
        .JtypeM(JtypeM),
        .RegWriteM(RegWriteM),
        .MemReadM(MemReadM),
        .MemWriteM(MemWriteM),
        .BranchF(BranchF),
        .ALUOutM(ALUOutM),
        .ALUSelectM(ALUSelectM),
        .StoreCounterOutM(StoreCounterOutM),
        .PCPlusImmF(PCPlusImmF)
    );

    // Task to run a single test
    task run_test;
        input [127*8:1] test_name;
        begin
            #10;
            $display("== %s ==", test_name);
            $display("PCD = 0x%08h", PCD);
            $display("RegOut1D = 0x%08h | RegOut2D = 0x%08h", RegOut1D, RegOut2D);
            $display("ImmGenOutD = 0x%08h", ImmGenOutD);
            $display("ALUSelectD = 0b%06b", ALUSelectD);
            $display("WriteAddressD = %d | WriteAddressM = %d", WriteAddressD, WriteAddressM);
            $display("ALUOutM = 0x%08h", ALUOutM);
            $display("PCPlusImmF = 0x%08h", PCPlusImmF);
            $display("StoreCounterOutM = 0x%08h", StoreCounterOutM);
            $display("BranchF = %b\n", BranchF);
        end
    endtask

    initial begin
        $display("\n--- Execution Cycle Testbench Start ---\n");

        // Common control inputs
        PCD = 32'h00000004;
        WriteAddressD = 5'd10;
        JtypeD = 0; RegWriteD = 1; MemReadD = 0; MemWriteD = 0;
        PCSelectD = 0;

        // Test 1: ADD
        RegOut1D = 32'h00000005;
        RegOut2D = 32'h00000003;
        ImmSelectD = 0;
        ALUSelectD = 6'b011100; // ADD
        run_test("ADD");

        // Test 2: SUB
        ALUSelectD = 6'b011101; // SUB
        run_test("SUB");

        // Test 3: ADDI
        ImmSelectD = 1;
        ImmGenOutD = 32'h00000008;
        ALUSelectD = 6'b010011; // ADDI
        run_test("ADDI");

        // Test 4: SLT
        ImmSelectD = 0;
        RegOut1D = 32'h00000002;
        RegOut2D = 32'h00000005;
        ALUSelectD = 6'b011110; // SLT
        run_test("SLT");

        // Test 5: SLTI
        ImmSelectD = 1;
        RegOut1D = 32'h00000002;
        ImmGenOutD = 32'h00000006;
        ALUSelectD = 6'b010100; // SLTI
        run_test("SLTI");

        // Test 6: SLL
        ImmSelectD = 0;
        RegOut1D = 32'h00000001;
        RegOut2D = 32'h00000004;
        ALUSelectD = 6'b100000; // SLL
        run_test("SLL");

        // Test 7: SRL
        RegOut1D = 32'h000000F0;
        ALUSelectD = 6'b100010; // SRL
        run_test("SRL");

        // Test 8: SRA
        RegOut1D = 32'hFFFFFFF0;
        ALUSelectD = 6'b100011; // SRA
        run_test("SRA");

        // Test 9: XOR
        RegOut1D = 32'hAAAA5555;
        RegOut2D = 32'h5555AAAA;
        ALUSelectD = 6'b011111; // XOR
        run_test("XOR");

        // Test 10: OR
        ALUSelectD = 6'b100100; // OR
        run_test("OR");

        // Test 11: AND
        ALUSelectD = 6'b100101; // AND
        run_test("AND");

        // Test 12: BEQ
        RegOut1D = 32'hDEADBEEF;
        RegOut2D = 32'hDEADBEEF;
        ImmSelectD = 0;
        ImmGenOutD = 32'h00000010;
        ALUSelectD = 6'b000101; // BEQ
        run_test("BEQ");

        // Test 13: BNE
        RegOut2D = 32'hCAFEBABE;
        ALUSelectD = 6'b000110; // BNE
        run_test("BNE");

        // Test 14: MUL
        RegOut1D = 32'h00000004;
        RegOut2D = 32'h00000005;
        ALUSelectD = 6'b110000; // MUL
        run_test("MUL");

        // Test 15: DIV
        RegOut1D = 32'h00000010;
        RegOut2D = 32'h00000004;
        ALUSelectD = 6'b110100; // DIV
        run_test("DIV");

        // Test 16: REM
        RegOut1D = 32'h00000013;
        RegOut2D = 32'h00000004;
        ALUSelectD = 6'b110110; // REM
        run_test("REM");

        $display("\n--- Testbench Completed ---\n");
        $finish;
    end

endmodule
