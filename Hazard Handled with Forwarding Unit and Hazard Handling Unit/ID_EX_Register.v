module ID_EX_Register(
    input         clk,
    input         reset,

    // Inputs from Decode stage
    input  [4:0]  WriteAddressE,
    input         JtypeE,
    input         RegWriteE,
    input  [5:0]  ALUSelectE,
    input         PCSelectE,
    input         ImmSelectE,
    input         MemReadE,
    input         MemWriteE,
    input  [31:0] ReadOut1E,
    input  [31:0] ReadOut2E,
    input  [31:0] ImmGenOutE,
    input  [31:0] PCE,
    input  [4:0]  Rs1E,
    input  [4:0]  Rs2E,

    // Outputs to Execute stage
    output reg [4:0]  WriteAddressD2E,
    output reg        JtypeD2E,
    output reg        RegWriteD2E,
    output reg [5:0]  ALUSelectD2E,
    output reg        PCSelectD2E,
    output reg        ImmSelectD2E,
    output reg        MemReadD2E,
    output reg        MemWriteD2E,
    output reg [31:0] ReadOut1D2E,
    output reg [31:0] ReadOut2D2E,
    output reg [31:0] ImmGenOutD2E,
    output reg [31:0] PCD2E,
    output reg [4:0]  Rs1D2E,
    output reg [4:0]  Rs2D2E
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WriteAddressD2E <= 0;
            JtypeD2E        <= 0;
            RegWriteD2E     <= 0;
            ALUSelectD2E    <= 0;
            PCSelectD2E     <= 0;
            ImmSelectD2E    <= 0;
            MemReadD2E      <= 0;
            MemWriteD2E     <= 0;
            ReadOut1D2E     <= 0;
            ReadOut2D2E     <= 0;
            ImmGenOutD2E    <= 0;
            PCD2E           <= 0;
            Rs1D2E          <= 0;
            Rs2D2E          <= 0;
        end else begin
            WriteAddressD2E <= WriteAddressE;
            JtypeD2E        <= JtypeE;
            RegWriteD2E     <= RegWriteE;
            ALUSelectD2E    <= ALUSelectE;
            PCSelectD2E     <= PCSelectE;
            ImmSelectD2E    <= ImmSelectE;
            MemReadD2E      <= MemReadE;
            MemWriteD2E     <= MemWriteE;
            ReadOut1D2E     <= ReadOut1E;
            ReadOut2D2E     <= ReadOut2E;
            ImmGenOutD2E    <= ImmGenOutE;
            PCD2E           <= PCE;
            Rs1D2E          <= Rs1E;
            Rs2D2E          <= Rs2E;
        end
    end

endmodule
