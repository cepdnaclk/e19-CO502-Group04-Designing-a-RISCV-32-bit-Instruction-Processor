module EX_MEM_Register (
    input         clk,
    input         reset,

    // Inputs from Execute stage
    input  [4:0]  WriteAddressM,
    input         JtypeM,
    input         RegWriteM,
    input         MemReadM,
    input         MemWriteM,
    input         BranchM,
    input  [5:0]  ALUSelectM,
    input  [31:0] ALUOutM,
    input  [31:0] StoreCounterOutM,
    input  [31:0] PCPlusImmM,

    // Outputs to Memory stage
    output reg [4:0]  WriteAddressE2M,
    output reg        JtypeE2M,
    output reg        RegWriteE2M,
    output reg        MemReadE2M,
    output reg        MemWriteE2M,
    output reg        BranchE2M,
    output reg [5:0]  ALUSelectE2M,
    output reg [31:0] ALUOutE2M,
    output reg [31:0] StoreCounterOutE2M,
    output reg [31:0] PCPlusImmE2M
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WriteAddressE2M     <= 0;
            JtypeE2M            <= 0;
            RegWriteE2M         <= 0;
            MemReadE2M          <= 0;
            MemWriteE2M         <= 0;
            BranchE2M           <= 0;
            ALUSelectE2M        <= 0;
            ALUOutE2M           <= 0;
            StoreCounterOutE2M  <= 0;
            PCPlusImmE2M        <= 0;
        end else begin
            WriteAddressE2M     <= WriteAddressM;
            JtypeE2M            <= JtypeM;
            RegWriteE2M         <= RegWriteM;
            MemReadE2M          <= MemReadM;
            MemWriteE2M         <= MemWriteM;
            BranchE2M           <= BranchM;
            ALUSelectE2M        <= ALUSelectM;
            ALUOutE2M           <= ALUOutM;
            StoreCounterOutE2M  <= StoreCounterOutM;
            PCPlusImmE2M        <= PCPlusImmM;
        end
    end

endmodule
