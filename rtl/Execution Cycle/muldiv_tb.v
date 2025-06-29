`timescale 1ns/1ps

module tb_muldiv;

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
        $display("Time\taluSelect\trs1\t\trs2\t\tresult");

        // Test MUL (lower 32 bits)
        rs1 = 32'd10; rs2 = 32'd20; aluSelect = 6'b100110; #10;
        $display("%0t\tMUL\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Test MULH (signed * signed upper 32 bits)
        rs1 = -32'd8; rs2 = 32'd7; aluSelect = 6'b100111; #10;
        $display("%0t\tMULH\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Test MULHSU (signed rs1 * unsigned rs2)
        rs1 = -32'd8; rs2 = 32'd7; aluSelect = 6'b101000; #10;
        $display("%0t\tMULHSU\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Test MULHU (unsigned * unsigned upper 32 bits)
        rs1 = 32'hFFFFFFFF; rs2 = 32'd2; aluSelect = 6'b101001; #10;
        $display("%0t\tMULHU\t\t%h\t%h\t%h", $time, rs1, rs2, result);

        // Test DIV (signed division)
        rs1 = -32'd40; rs2 = 32'd5; aluSelect = 6'b101010; #10;
        $display("%0t\tDIV\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Test DIVU (unsigned division)
        rs1 = 32'hFFFFFFFE; rs2 = 32'd2; aluSelect = 6'b101011; #10;
        $display("%0t\tDIVU\t\t%h\t%h\t%h", $time, rs1, rs2, result);

        // Test REM (signed remainder)
        rs1 = -32'd17; rs2 = 32'd4; aluSelect = 6'b101100; #10;
        $display("%0t\tREM\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Test REMU (unsigned remainder)
        rs1 = 32'd17; rs2 = 32'd4; aluSelect = 6'b101101; #10;
        $display("%0t\tREMU\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        // Division by zero cases
        rs1 = 32'd42; rs2 = 0; aluSelect = 6'b101010; #10;
        $display("%0t\tDIV/0\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        rs1 = 32'd42; rs2 = 0; aluSelect = 6'b101011; #10;
        $display("%0t\tDIVU/0\t\t%d\t%d\t%d", $time, rs1, rs2, result);

        $finish;
    end

endmodule
