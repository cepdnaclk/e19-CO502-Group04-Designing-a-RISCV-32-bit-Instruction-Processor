`timescale 1ns/1ps

module LoadStoreUnit_tb;

    // Testbench signals
    reg [31:0] rs1;
    reg [31:0] imm;
    reg [5:0] aluSelect;
    wire [31:0] address;

    // Instantiate the DUT (Device Under Test)
    LoadStoreUnit dut (
        .rs1(rs1),
        .imm(imm),
        .aluSelect(aluSelect),
        .address(address)
    );

    // Task to display the results
    task show;
        begin
            $display("time=%0t  aluSel=%b  rs1=%d  imm=%d  -> address=%d",
                     $time, aluSelect, rs1, imm, address);
        end
    endtask

    initial begin
        $display("\n=== LoadStoreUnit Testbench ===");

        // Test Case 1: aluSelect in the range (LB)
        rs1 = 32'h0000_1000;
        imm = 32'h0000_0010;
        aluSelect = 6'b001011;   // LB
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 2: aluSelect in the range (LH)
        aluSelect = 6'b001100;   // LH
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 3: aluSelect in the range (LW)
        aluSelect = 6'b001101;   // LW
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 4: aluSelect in the range (LBU)
        aluSelect = 6'b001110;   // LBU
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 5: aluSelect in the range (LHU)
        aluSelect = 6'b001111;   // LHU
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 6: aluSelect in the range (SB)
        aluSelect = 6'b010000;   // SB
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 7: aluSelect in the range (SH)
        aluSelect = 6'b010001;   // SH
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 8: aluSelect in the range (SW)
        aluSelect = 6'b010010;   // SW
        #5; show();              // expect 0x00001010 (rs1 + imm)

        // Test Case 9: aluSelect outside the range
        aluSelect = 6'b011000;   // Outside range
        #5; show();              // expect 0x00000000

        // Test Case 10: Another outside aluSelect value
        aluSelect = 6'b000111;   // Outside range
        #5; show();              // expect 0x00000000

        $display("\nTestbench complete.");
        $finish;
    end

endmodule
