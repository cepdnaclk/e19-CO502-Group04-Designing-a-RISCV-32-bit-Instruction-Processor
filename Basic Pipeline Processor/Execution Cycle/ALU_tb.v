`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [31:0] rs1;
    reg [31:0] rs2;
    reg [5:0] aluSelect;

    // Outputs
    wire [31:0] result;
    wire branch_taken;

    // Instantiate the ALU
    ALU uut (
        .rs1(rs1),
        .rs2(rs2),
        .aluSelect(aluSelect),
        .result(result),
        .branch_taken(branch_taken)
    );

    initial begin
        $display("Starting ALU testbench...");
        $monitor("Time=%0t | aluSelect=%b | rs1=%h | rs2=%h | result=%h | branch_taken=%b", 
                  $time, aluSelect, rs1, rs2, result, branch_taken);

        // Wait for global reset
        #10;

        // === U-Type (e.g., LUI) ===
        rs1 = 32'h00000000;     // Not used, but set to zero
        rs2 = 32'h0000A000;     // Immediate
        aluSelect = 6'b000001;  // LUI
        #10;

        // === R-Type ADD ===
        rs1 = 32'h00000005;
        rs2 = 32'h00000003;
        aluSelect = 6'b000101;  // ADD
        #10;

        // === R-Type SUB ===
        rs1 = 32'h00000009;
        rs2 = 32'h00000004;
        aluSelect = 6'b000110;  // SUB
        #10;

        // === MUL ===
        rs1 = 32'h00000002;
        rs2 = 32'h00000004;
        aluSelect = 6'b010011;  // MUL
        #10;

        // === DIV ===
        rs1 = 32'h00000008;
        rs2 = 32'h00000002;
        aluSelect = 6'b010110;  // DIV
        #10;

        // === Load Word (LW) ===
        rs1 = 32'h00001000;
        rs2 = 32'h00000004;
        aluSelect = 6'b001101;  // LW
        #10;

        // === Store Byte (SB) ===
        rs1 = 32'h00002000;
        rs2 = 32'h00000008;
        aluSelect = 6'b010000;  // SB
        #10;

        // === JAL ===
        rs1 = 32'h00000000;
        rs2 = 32'h00003000;
        aluSelect = 6'b000011;  // JAL
        #10;

        // === JALR ===
        rs1 = 32'h00000010;
        rs2 = 32'h00000004;
        aluSelect = 6'b000100;  // JALR
        #10;

        // === BEQ ===
        rs1 = 32'h000000AA;
        rs2 = 32'h000000AA;
        aluSelect = 6'b001010;  // BEQ
        #10;

        // === BNE ===
        rs1 = 32'h000000AA;
        rs2 = 32'h000000BB;
        aluSelect = 6'b001100;  // BNE
        #10;

        $display("Testbench completed.");
        $finish;
    end

endmodule
