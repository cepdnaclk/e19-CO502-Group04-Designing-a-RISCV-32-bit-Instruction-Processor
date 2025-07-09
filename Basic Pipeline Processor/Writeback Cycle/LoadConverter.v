module LoadConverter (
    input  [31:0] inputData,
    input  [5:0]  aluSelect,
    output reg [31:0] outputData
);

    always @(*) begin
        case(aluSelect)
            6'b001011: outputData = inputData | 32'hffffff00; // LB
            6'b001100: outputData = inputData | 32'hffff0000; // LH
            6'b001110: outputData = inputData & 32'h000000ff; // LBU
            6'b001111: outputData = inputData & 32'h0000ffff; // LHU
            default:   outputData = inputData; // Default passthrough
        endcase
    end

endmodule
