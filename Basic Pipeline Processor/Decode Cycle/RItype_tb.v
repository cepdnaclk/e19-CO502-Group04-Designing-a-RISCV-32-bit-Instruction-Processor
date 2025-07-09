`timescale 1ns/1ps

module tb_RItype;

    reg  [31:0] a, b;
    reg  [5:0]  aluSelect;
    wire [31:0] result;

    // Instantiate the module
    RItype uut (
        .a(a),
        .b(b),
        .aluSelect(aluSelect),
        .result(result)
    );

    initial begin
        $display("Time\taluSel\tOperation\t\ta\t\tb\t\tResult");

        // ADDI
        a = 32'd10; b = 32'd5; aluSelect = 6'b010011; #10;
        $display("%0t\tADDI\t\t\t%d\t%d\t%d", $time, a, b, result);

        // ANDI
        a = 32'hFF00FF00; b = 32'h0F0F0F0F; aluSelect = 6'b011000; #10;
        $display("%0t\tANDI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // ORI
        a = 32'hAA00AA00; b = 32'h00FF00FF; aluSelect = 6'b010111; #10;
        $display("%0t\tORI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // XORI
        a = 32'h12345678; b = 32'hFFFFFFFF; aluSelect = 6'b010110; #10;
        $display("%0t\tXORI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SLLI
        a = 32'h00000001; b = 32'd4; aluSelect = 6'b011001; #10;
        $display("%0t\tSLLI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SRLI
        a = 32'h00000010; b = 32'd1; aluSelect = 6'b011010; #10;
        $display("%0t\tSRLI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SRAI
        a = 32'hFFFFFFF0; b = 32'd2; aluSelect = 6'b011011; #10;
        $display("%0t\tSRAI\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SLTI (signed less than)
        a = -5; b = 0; aluSelect = 6'b010100; #10;
        $display("%0t\tSLTI\t\t\t%d\t%d\t%d", $time, a, b, result);

        // SLTIU (unsigned less than)
        a = 32'h00000001; b = 32'hFFFFFFFF; aluSelect = 6'b010101; #10;
        $display("%0t\tSLTIU\t\t\t%h\t%h\t%d", $time, a, b, result);

        // ADD (R-type)
        a = 32'd20; b = 32'd22; aluSelect = 6'b011100; #10;
        $display("%0t\tADD\t\t\t%d\t%d\t%d", $time, a, b, result);

        // SUB
        a = 32'd50; b = 32'd20; aluSelect = 6'b100100; #10;
        $display("%0t\tSUB\t\t\t%d\t%d\t%d", $time, a, b, result);

        // AND
        a = 32'hFF00FF00; b = 32'hF0F0F0F0; aluSelect = 6'b100011; #10;
        $display("%0t\tAND\t\t\t%h\t%h\t%h", $time, a, b, result);

        // OR
        a = 32'hAA00AA00; b = 32'h00FF00FF; aluSelect = 6'b100010; #10;
        $display("%0t\tOR\t\t\t%h\t%h\t%h", $time, a, b, result);

        // XOR
        a = 32'h12345678; b = 32'h87654321; aluSelect = 6'b100000; #10;
        $display("%0t\tXOR\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SLL
        a = 32'h00000001; b = 32'd8; aluSelect = 6'b011101; #10;
        $display("%0t\tSLL\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SRL
        a = 32'h00000100; b = 32'd2; aluSelect = 6'b100001; #10;
        $display("%0t\tSRL\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SRA
        a = 32'hFFFFFF80; b = 32'd4; aluSelect = 6'b100101; #10;
        $display("%0t\tSRA\t\t\t%h\t%h\t%h", $time, a, b, result);

        // SLT
        a = -1; b = 1; aluSelect = 6'b011110; #10;
        $display("%0t\tSLT\t\t\t%d\t%d\t%d", $time, a, b, result);

        // SLTU
        a = 32'h00000001; b = 32'hFFFFFFFF; aluSelect = 6'b011111; #10;
        $display("%0t\tSLTU\t\t\t%h\t%h\t%d", $time, a, b, result);

        // Default case
        a = 32'd123; b = 32'd456; aluSelect = 6'b111111; #10;
        $display("%0t\tDefault\t\t%d\t%d\t%d", $time, a, b, result);

        $finish;
    end

endmodule
