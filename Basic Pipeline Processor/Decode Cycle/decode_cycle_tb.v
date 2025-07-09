`timescale 1ns / 1ps

module decode_cycle_tb;

  // Inputs
  reg clk, reset;
  reg RegWriteW;
  reg [4:0] WriteAddressW;
  reg [31:0] writeDataW;
  reg [31:0] instructionF;
  reg [31:0] PCF;

  // Outputs
  wire [31:0] PCE, ReadOut1E, ReadOut2E, ImmGenOutE;
  wire JtypeE, RegWriteE, PCSelectE, ImmSelectE, MemReadE, MemWriteE;
  wire [5:0] ALUSelectE;
  wire [4:0] WriteAddressE;

  // Instantiate DUT
  decode_cycle uut (
    .clk(clk),
    .reset(reset),
    .WriteAddressE(WriteAddressE),
    .WriteAddressW(WriteAddressW),
    .instructionF(instructionF),
    .PCF(PCF),
    .RegWriteW(RegWriteW),
    .writeDataW(writeDataW),
    .JtypeE(JtypeE),
    .RegWriteE(RegWriteE),
    .ALUSelectE(ALUSelectE),
    .PCSelectE(PCSelectE),
    .ImmSelectE(ImmSelectE),
    .MemReadE(MemReadE),
    .MemWriteE(MemWriteE),
    .ReadOut1E(ReadOut1E),
    .ReadOut2E(ReadOut2E),
    .ImmGenOutE(ImmGenOutE),
    .PCE(PCE)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Task to display outputs
  task print_outputs;
    begin
      $display("\nTime: %0t", $time);
      $display("Instruction   = %h", instructionF);
      $display("PCF           = %h", PCF);
      $display("WriteAddressE = %d", WriteAddressE);
      $display("ReadOut1E     = %h", ReadOut1E);
      $display("ReadOut2E     = %h", ReadOut2E);
      $display("ImmGenOutE    = %h", ImmGenOutE);
      $display("RegWriteE     = %b", RegWriteE);
      $display("ALUSelectE    = %b", ALUSelectE);
      $display("MemReadE      = %b", MemReadE);
      $display("MemWriteE     = %b", MemWriteE);
      $display("PCSelectE     = %b", PCSelectE);
      $display("ImmSelectE    = %b", ImmSelectE);
      $display("JtypeE        = %b", JtypeE);
      $display("=============================");
    end
  endtask

  // Stimulus
  initial begin
    // Initial values
    clk = 0;
    reset = 1;
    RegWriteW = 0;
    WriteAddressW = 0;
    writeDataW = 0;
    instructionF = 0;
    PCF = 0;

    #10 reset = 0;

    // Simulate writing to register x1
    RegWriteW = 1;
    WriteAddressW = 5'd1;
    writeDataW = 32'hDEAD_BEEF;
    instructionF = 32'h00000013; // NOP
    PCF = 32'h1000;
    #10;

    // R-type: ADD x5, x1, x1 (x5 = x1 + x1)
    RegWriteW = 0;
    instructionF = {7'b0000000, 5'd1, 5'd1, 3'b000, 5'd5, 7'b0110011}; // ADD x5, x1, x1
    PCF = 32'h1004;
    #10 print_outputs;

    // I-type: ADDI x6, x1, 10
    instructionF = {12'd10, 5'd1, 3'b000, 5'd6, 7'b0010011};
    PCF = 32'h1008;
    #10 print_outputs;

    // S-type: SW x1, 4(x2)
    instructionF = {7'd4, 5'd1, 5'd2, 3'b010, 5'd3, 7'b0100011}; // SW x1 to offset 4(x2)
    PCF = 32'h100C;
    #10 print_outputs;

    // B-type: BEQ x1, x2, 8
    instructionF = {7'b0000000, 5'd1, 5'd2, 3'b000, 5'd0, 7'b1100011}; // BEQ x1, x2, 0
    PCF = 32'h1010;
    #10 print_outputs;

    // U-type: LUI x7, 0x12345
    instructionF = {20'h12345, 5'd7, 7'b0110111}; // LUI x7, 0x12345000
    PCF = 32'h1014;
    #10 print_outputs;

    // J-type: JAL x1, 0x10
    instructionF = {8'h00, 1'b0, 10'b0000000100, 1'b0, 5'd1, 7'b1101111}; // JAL x1, 0x10
    PCF = 32'h1018;
    #10 print_outputs;

    $finish;
  end

endmodule
