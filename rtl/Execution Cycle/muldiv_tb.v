`timescale 1ns / 1ps

module muldiv_tb;

    reg  [31:0] rs1, rs2;
    reg  [5:0]  aluSelect;
    wire [31:0] result;

    // Instantiate the module
    muldiv uut (
        .rs1(rs1),
        .rs2(rs2),
        .aluSelect(aluSelect),
        .result(result)
    );

    initial begin
        $display("Starting muldiv testbench...");
        $monitor("aluSelect = %b, rs1 = %d, rs2 = %d, result = %d", aluSelect, rs1, rs2, result);

        // Test MUL
        rs1 = 32'd6; rs2 = 32'd7; aluSelect = 6'b101001; #10;

        // Test MULH (signed * signed)
        rs1 = -32'sd10; rs2 = 32'sd100000; aluSelect = 6'b101010; #10;

        // Test MULHSU (signed * unsigned)
        rs1 = -32'sd10; rs2 = 32'd100000; aluSelect = 6'b101011; #10;

        // Test MULHU (unsigned * unsigned)
        rs1 = 32'd50000; rs2 = 32'd100000; aluSelect = 6'b101100; #10;

        // Test DIV (signed)
        rs1 = -32'sd100; rs2 = 32'sd25; aluSelect = 6'b101101; #10;

        // Test DIVU (unsigned)
        rs1 = 32'd100; rs2 = 32'd25; aluSelect = 6'b101110; #10;

        // Test REM (signed)
        rs1 = -32'sd101; rs2 = 32'sd20; aluSelect = 6'b101111; #10;

        // Test REMU (unsigned)
        rs1 = 32'd101; rs2 = 32'd20; aluSelect = 6'b110000; #10;

        // Test division by zero
        rs1 = 32'd123; rs2 = 32'd0; aluSelect = 6'b101101; #10; // DIV by zero
        rs1 = 32'd123; rs2 = 32'd0; aluSelect = 6'b101111; #10; // REM by zero

        $display("Testbench completed.");
        $stop;
    end

endmodule
