module forwarding_unit(reset, RegWriteM, RegWriteW, RD_M, RD_W, Rs1_E, Rs2_E, ForwardAE, ForwardBE);

    input reset, RegWriteM, RegWriteW;
    input [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
    output [1:0] ForwardAE, ForwardBE;

    assign ForwardAE = (reset == 1'b1) ? 2'b00 :
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;

    assign ForwardBE = (reset == 1'b1) ? 2'b00 :
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

endmodule