`timescale 1ns/1ps

module LoadConverter_tb;

    // Testbench signals
    reg  [31:0] inputData;
    reg  [5:0]  aluSelect;
    wire [31:0] outputData;

    // Instantiate the LoadUnit
    LoadConverter dut (
        .inputData(inputData),
        .aluSelect(aluSelect),
        .outputData(outputData)
    );

    // Task to run a single test case
    task run_test;
        input [5:0] select;
        input [31:0] inData;
        begin
            aluSelect  = select;
            inputData  = inData;
            #10; // Wait for output to settle
            $display("aluSelect = %b | inputData = 0x%h | outputData = 0x%h", aluSelect, inputData, outputData);
        end
    endtask

    initial begin
        $display("Starting LoadUnit testbench...");

        // Test LB (mask to lowest byte)
        run_test(6'b001011, 32'hDEADBEEF); // Expected output: 0x000000EF

        // Test LH (mask to lowest halfword)
        run_test(6'b001100, 32'hCAFEBABE); // Expected output: 0x0000BABE

        // Test LBU (simulate zero-extended load — here using OR for placeholder)
        run_test(6'b001110, 32'h000000AB); // Expected output: 0x111111AB (not actual LBU behavior)

        // Test LHU (simulate zero-extended load — placeholder logic)
        run_test(6'b001111, 32'h00001234); // Expected output: 0x11111234 (not actual LHU behavior)

        // Test default passthrough
        run_test(6'b000000, 32'h12345678); // Expected output: 0x12345678

        $display("Testbench complete.");
        $finish;
    end

endmodule
