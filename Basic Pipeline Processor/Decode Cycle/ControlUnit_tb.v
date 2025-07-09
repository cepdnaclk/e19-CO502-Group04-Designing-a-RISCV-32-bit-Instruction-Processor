`timescale 1ns/1ps

module ControlUnit_tb;

    // Inputs
    reg [31:0] instruction;

    // Outputs
    wire [5:0] aluSelect;
    wire MemWrite, MemRead, ImmSelect, PCSelect, regWrite, Jtype;

    // Instantiate the Unit Under Test (UUT)
    ControlUnit uut (
        .instruction(instruction),
        .aluSelect(aluSelect),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ImmSelect(ImmSelect),
        .PCSelect(PCSelect),
        .regWrite(regWrite),
        .Jtype(Jtype)
    );

    // Task to display results
    task print_signals;
        begin
            $display("Instruction: %h", instruction);
            $display("aluSelect: %b | MemWrite: %b | MemRead: %b | ImmSelect: %b | PCSelect: %b | regWrite: %b | Jtype: %b",
                     aluSelect, MemWrite, MemRead, ImmSelect, PCSelect, regWrite, Jtype);
            $display("-----------------------------------------------------");
        end
    endtask

    initial begin
        $display("Starting Control Unit Testbench...\n");

        // Format: {funct7, rs2, rs1, funct3, rd, opcode}
        // RV32I — R-type
        instruction = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3, x1, x2
        #10; print_signals;

        instruction = 32'b0100000_00010_00001_000_00011_0110011; // SUB x3, x1, x2
        #10; print_signals;

        instruction = 32'b0000000_00010_00001_111_00011_0110011; // AND x3, x1, x2
        #10; print_signals;

        // RV32I — I-type
        instruction = 32'b000000000010_00001_000_00011_0010011; // ADDI x3, x1, 2
        #10; print_signals;

        instruction = 32'b000000000010_00001_111_00011_0010011; // ANDI x3, x1, 2
        #10; print_signals;

        // RV32I — Load
        instruction = 32'b000000000100_00001_010_00011_0000011; // LW x3, 4(x1)
        #10; print_signals;

        // RV32I — Store
        instruction = 32'b0000000_00011_00001_010_00010_0100011; // SW x3, 2(x1)
        #10; print_signals;

        // RV32I — Branch
        instruction = 32'b0000000_00010_00001_000_00000_1100011; // BEQ x1, x2, offset
        #10; print_signals;

        // RV32I — LUI
        instruction = 32'b00000000000000000001_00011_0110111; // LUI x3, 0x1000
        #10; print_signals;

        // RV32I — AUIPC
        instruction = 32'b00000000000000000001_00011_0010111; // AUIPC x3, 0x1000
        #10; print_signals;

        // RV32I — JAL
        instruction = 32'b00000000000000000000_00011_1101111; // JAL x3, offset
        #10; print_signals;

        // RV32I — JALR
        instruction = 32'b000000000100_00001_000_00011_1100111; // JALR x3, x1, 4
        #10; print_signals;

        // RV32I — FENCE
        instruction = 32'b000000000000_00000_000_00000_0001111; // FENCE
        #10; print_signals;

        // RV32I — ECALL
        instruction = 32'b000000000000_00000_000_00000_1110011; // ECALL
        #10; print_signals;

        // RV32M — R-type
        instruction = 32'b0000001_00010_00001_000_00011_0110011; // MUL x3, x1, x2
        #10; print_signals;

        instruction = 32'b0000001_00010_00001_001_00011_0110011; // MULH x3, x1, x2
        #10; print_signals;

        instruction = 32'b0000001_00010_00001_100_00011_0110011; // DIV x3, x1, x2
        #10; print_signals;

        instruction = 32'b0000001_00010_00001_110_00011_0110011; // REM x3, x1, x2
        #10; print_signals;

        $display("Testbench completed.");
        $finish;
    end

endmodule
