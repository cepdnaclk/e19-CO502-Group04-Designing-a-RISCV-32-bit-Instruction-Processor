`timescale 1ns/1ps

module tb_LoadConverter;

    reg  [31:0] inputData;
    reg  [5:0]  aluSelect;
    wire [31:0] outputData;

    // Instantiate the module
    LoadConverter uut (
        .inputData(inputData),
        .aluSelect(aluSelect),
        .outputData(outputData)
    );

    initial begin
        // Waveform dump setup
        $dumpfile("LoadConverter_tb.vcd");     // Name of the VCD file
        $dumpvars(0, tb_LoadConverter);        // Dump all variables in this module

        $display("Time\taluSelect\tinputData\t\toutputData");

        // Test 1: LB (expect sign-extend byte)
        inputData = 32'h000000A5; // A5 = 0b10100101
        aluSelect = 6'b001011; #10;
        $display("%0t\tLB\t\t0x%h\t\t0x%h", $time, inputData, outputData);

        // Test 2: LH (expect sign-extend halfword)
        inputData = 32'h00001234;
        aluSelect = 6'b001100; #10;
        $display("%0t\tLH\t\t0x%h\t\t0x%h", $time, inputData, outputData);

        // Test 3: LBU (expect zero-extend byte)
        inputData = 32'hABCD00EF;
        aluSelect = 6'b001110; #10;
        $display("%0t\tLBU\t\t0x%h\t\t0x%h", $time, inputData, outputData);

        // Test 4: LHU (expect zero-extend halfword)
        inputData = 32'h12345678;
        aluSelect = 6'b001111; #10;
        $display("%0t\tLHU\t\t0x%h\t\t0x%h", $time, inputData, outputData);

        // Test 5: Default passthrough
        inputData = 32'hDEADBEEF;
        aluSelect = 6'b000000; #10;
        $display("%0t\tDefault\t\t0x%h\t\t0x%h", $time, inputData, outputData);

        $finish;
    end

endmodule

