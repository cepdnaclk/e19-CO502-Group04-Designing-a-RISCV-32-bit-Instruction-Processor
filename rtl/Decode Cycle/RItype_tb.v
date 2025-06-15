`timescale 1ns/1ps

module RItype_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [5:0]  aluSelect;
    wire [31:0] result;

    integer i;

    // Instantiate DUT
    RItype uut (
        .a(a),
        .b(b),
        .aluSelect(aluSelect),
        .result(result)
    );

    // Instruction label array
    reg [100*8:1] instr_labels [0:19];

    initial begin
        $dumpfile("RItype_tb.vcd");
        $dumpvars(0, RItype_tb);

        // Initialize labels
        instr_labels[0]  = "ADDI";
        instr_labels[1]  = "ANDI";
        instr_labels[2]  = "ORI";
        instr_labels[3]  = "XORI";
        instr_labels[4]  = "SLLI";
        instr_labels[5]  = "SRLI";
        instr_labels[6]  = "SRAI";
        instr_labels[7]  = "SLTI";
        instr_labels[8]  = "SLTIU";
        instr_labels[9]  = "ADD";
        instr_labels[10] = "SUB";
        instr_labels[11] = "AND";
        instr_labels[12] = "OR";
        instr_labels[13] = "XOR";
        instr_labels[14] = "SLL";
        instr_labels[15] = "SRL";
        instr_labels[16] = "SRA";
        instr_labels[17] = "SLT";
        instr_labels[18] = "SLTU";
        instr_labels[19] = "DEFAULT";

        // Test vector setup
        a = 32'h0000_00F0;
        b = 32'h0000_000F;

        $display("----- RItype ALU Test -----");
        $display("Time\tSel\tInstr\t\tA\t\tB\t\tResult");

        // Loop over opcodes to test
        for (i = 0; i <= 18; i = i + 1) begin
            aluSelect = i + 6'b010011; // Starting from 6'b010011
            #10;
            $display("%0t\t%02h\t%s\t%h\t%h\t%h", $time, aluSelect, instr_labels[i], a, b, result);
        end

        // Test default
        aluSelect = 6'b111111;
        #10;
        $display("%0t\t%02h\t%s\t%h\t%h\t%h", $time, aluSelect, instr_labels[19], a, b, result);

        $finish;
    end

endmodule
