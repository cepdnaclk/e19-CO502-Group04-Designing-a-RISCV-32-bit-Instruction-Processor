module Reg_File(
    input clk,
    input reset,
    input RegWrite,
    input [4:0] Rs1,
    input [4:0] Rs2,
    input [4:0] Rd,
    input [31:0] Write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] reg_array [31:0];
    integer i;

    // Write logic with x0 protection
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end else if (RegWrite && (Rd != 0)) begin
            reg_array[Rd] <= Write_data;
        end
        // Writes to x0 (Rd==0) are ignored
    end

    // Read logic (x0 always returns 0)
    assign read_data1 = (Rs1 == 0) ? 32'b0 : reg_array[Rs1];
    assign read_data2 = (Rs2 == 0) ? 32'b0 : reg_array[Rs2];

endmodule
