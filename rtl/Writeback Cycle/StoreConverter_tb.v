`timescale 1ns/1ps

module StoreConverter_tb;

    // Testbench signals
    reg  [31:0] inputData;
    reg  [5:0]  aluSelect;
    wire [31:0] outputData;

    // Instantiate the DUT (Device Under Test)
    StoreConverter dut (
        .inputData(inputData),
        .aluSelect(aluSelect),
        .outputData(outputData)
    );

    // Task to perform a test
    task run_test;
        input [5:0] select;
        input [31:0] inData;
        begin
            aluSelect  = select;
            inputData  = inData;
            #10; // Wait for result
            $display("aluSelect = %b | inputData = 0x%h | outputData = 0x%h", aluSelect, inputData, outputData);
        end
    endtask

    initial begin
        $display("Starting StoreConverter testbench...");

        // Test SB (store byte - mask to lowest 8 bits)
        run_test(6'b010000, 32'hDEADBEEF); // Expected: 0x000000EF

        // Test SH (store halfword - mask to lowest 16 bits)
        run_test(6'b010001, 32'hCAFEBABE); // Expected: 0x0000BABE

        // Test default passthrough
        run_test(6'b000000, 32'h12345678); // Expected: 0x12345678

        $display("StoreConverter testbench complete.");
        $finish;
    end

endmodule
