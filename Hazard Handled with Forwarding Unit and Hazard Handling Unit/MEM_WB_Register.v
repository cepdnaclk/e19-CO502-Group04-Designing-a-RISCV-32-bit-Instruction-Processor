module MEM_WB_Register (
    input         clk,
    input         reset,

    // Inputs from Memory stage
    input         JtypeW,
    input         RegWriteW,
    input         MemReadW,
    input  [31:0] DataMemOutW,
    input  [31:0] ALUOutW,
    input  [5:0]  ALUSelectW,
    input  [4:0]  WriteAddressW,

    // Outputs to WriteBack stage
    output reg        JtypeM2W,
    output reg        RegWriteM2W,
    output reg        MemReadM2W,
    output reg [31:0] DataMemOutM2W,
    output reg [31:0] ALUOutM2W,
    output reg [5:0]  ALUSelectM2W,
    output reg [4:0]  WriteAddressM2W
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            JtypeM2W        <= 1'b0;
            RegWriteM2W     <= 1'b0;
            MemReadM2W      <= 1'b0;
            DataMemOutM2W   <= 32'b0;
            ALUOutM2W       <= 32'b0;
            ALUSelectM2W    <= 4'b0;
            WriteAddressM2W <= 5'b0;
        end else begin
            JtypeM2W        <= JtypeW;
            RegWriteM2W     <= RegWriteW;
            MemReadM2W      <= MemReadW;
            DataMemOutM2W   <= DataMemOutW;
            ALUOutM2W       <= ALUOutW;
            ALUSelectM2W    <= ALUSelectW;
            WriteAddressM2W <= WriteAddressW;
        end
    end

endmodule
