`timescale 1ns / 1ps

module RItype_tb;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [5:0]  aluSelect;

    // Output
    wire [31:0] result;

    // Instantiate the DUT
    RItype dut (
        .a(a),
        .b(b),
        .aluSelect(aluSelect),
        .result(result)
    );

    // Task for displaying a formatted result
    task display_result;
        input [127:0] operation;
        begin
            #1;
            $display("%s: a = 0x%h, b = 0x%h, result = 0x%h", operation, a, b, result);
        end
    endtask

    initial begin
        $display("Starting RItype ALU Testbench...");
        
        // I-Type Instructions
        a = 32'h0000_000A; b = 32'h0000_0005;

        aluSelect = 6'b010011; // ADDI
        display_result("ADDI");

        aluSelect = 6'b011000; // ANDI
        display_result("ANDI");

        aluSelect = 6'b010111; // ORI
        display_result("ORI");

        aluSelect = 6'b010110; // XORI
        display_result("XORI");

        aluSelect = 6'b011001; // SLLI
        b = 32'd1;  // shift left by 1
        display_result("SLLI");

        aluSelect = 6'b011010; // SRLI
        b = 32'd1;  // shift right logical by 1
        display_result("SRLI");

        aluSelect = 6'b011011; // SRAI
        a = -32'sd8; b = 32'd1;
        display_result("SRAI");

        a = 32'd5; b = 32'd7;
        aluSelect = 6'b010100; // SLTI (signed less than)
        display_result("SLTI");

        aluSelect = 6'b010101; // SLTIU (unsigned less than)
        display_result("SLTIU");

        // R-Type Instructions
        a = 32'h0000_000F; b = 32'h0000_0001;

        aluSelect = 6'b011100; // ADD
        display_result("ADD");

        aluSelect = 6'b100100; // SUB
        display_result("SUB");

        aluSelect = 6'b100011; // AND
        display_result("AND");

        aluSelect = 6'b100010; // OR
        display_result("OR");

        aluSelect = 6'b100000; // XOR
        display_result("XOR");

        aluSelect = 6'b011101; // SLL
        b = 32'd4;
        display_result("SLL");

        aluSelect = 6'b100001; // SRL
        display_result("SRL");

        a = -32'sd32;
        aluSelect = 6'b100101; // SRA
        display_result("SRA");

        a = 32'd3; b = 32'd7;
        aluSelect = 6'b011110; // SLT
        display_result("SLT");

        aluSelect = 6'b011111; // SLTU
        display_result("SLTU");

        // Default case
        aluSelect = 6'b111111;
        display_result("DEFAULT");

        $display("RItype ALU Testbench complete.");
        $finish;
    end

endmodule

