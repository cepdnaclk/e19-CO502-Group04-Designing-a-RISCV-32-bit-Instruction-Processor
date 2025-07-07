module StoreConverter (
    input  [31:0] inputData,
    input  [5:0]  aluSelect,
    output reg [31:0] outputData
);

    always @(*) begin
        case (aluSelect)
            6'b010000: outputData = inputData & 32'h000000ff; // SB
            6'b010001: outputData = inputData & 32'h0000ffff; // SH
            default:   outputData = inputData;                // Default passthrough
        endcase
    end

endmodule
