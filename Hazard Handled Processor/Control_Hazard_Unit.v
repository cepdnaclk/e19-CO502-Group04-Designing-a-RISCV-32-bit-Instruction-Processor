module Control_Hazard_Unit (
    // From Decode stage
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    input  wire [31:0] pc,
    input  wire [31:0] imm,        // decoded immediate (for branches/jumps)
    input wire reset,

    // Control signals
    input  wire [5:0]  aluSelect,
    
    input wire [4:0] Rs1address, Rs2address, RdEAddress, RdMAddress, RdWAddress,
    input wire [31:0] ALUOutE, ALUOutM, MuxOutW,
    input wire RegWriteE, RegWriteM, RegWriteW,

    // Outputs
    output reg         FlushD,          // signal to stall fetch/decode
    output reg         target_pc_valid, // signal to indicate valid target_pc
    output reg [31:0]  target_pc        // jump/branch target address
);

    wire [31:0] Rs1_forwarded, Rs2_forwarded;

    assign Rs1_forwarded = (reset == 1'b1) ?  rs1 :
    	((RegWriteE == 1'b1) & (RdEAddress != 5'h00) & (RdEAddress == Rs1address)) ? ALUOutE :
    	((RegWriteM == 1'b1) & (RdMAddress != 5'h00) & (RdMAddress == Rs1address)) ? ALUOutM :
    	((RegWriteW == 1'b1) & (RdWAddress != 5'h00) & (RdWAddress == Rs1address)) ? MuxOutW : rs1;

                       
    assign Rs2_forwarded = (reset == 1'b1) ?  rs2 :
    	((RegWriteE == 1'b1) & (RdEAddress != 5'h00) & (RdEAddress == Rs2address)) ? ALUOutE :
    	((RegWriteM == 1'b1) & (RdMAddress != 5'h00) & (RdMAddress == Rs2address)) ? ALUOutM :
    	((RegWriteW == 1'b1) & (RdWAddress != 5'h00) & (RdWAddress == Rs2address)) ? MuxOutW : rs2;

    always @(*) begin
        // Default values
        FlushD           = 0;
        target_pc_valid  = 0;
        target_pc        = 32'b0;

        case (aluSelect)
            6'b000101: begin
                if (Rs1_forwarded == Rs2_forwarded) begin
                    FlushD           = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end

            6'b000110: begin
                if (Rs1_forwarded != Rs2_forwarded) begin
                    FlushD  = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end

            6'b000111: begin
                if ($signed(Rs1_forwarded) < $signed(Rs2_forwarded)) begin
                    FlushD           = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end

            6'b001000: begin
                if ($signed(Rs1_forwarded) >= $signed(Rs2_forwarded)) begin
                    FlushD           = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end

            6'b001001: begin
                if (Rs1_forwarded < Rs2_forwarded) begin
                    FlushD           = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end
            6'b001010: begin
                if (Rs1_forwarded >= Rs2_forwarded) begin
                    FlushD           = 1;
                    target_pc_valid  = 1;
                    target_pc        = pc + (imm); // Branch target address
                end
            end

            6'b000011: begin // JAL
                target_pc        = pc + (imm);
                target_pc_valid  = 1;
                FlushD           = 1;
            end

            6'b000100: begin // JALR
                target_pc        = (Rs1_forwarded + (imm)) & 32'hFFFFFFFE;
                target_pc_valid  = 1;
                FlushD           = 1;
            end

            default: begin
                FlushD           = 0;
                target_pc_valid  = 0;
                target_pc        = 32'b0;
            end
        endcase
    end

endmodule
