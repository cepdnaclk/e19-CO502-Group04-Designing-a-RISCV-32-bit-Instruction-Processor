module Masking_Mux_CU (
    input        FlushE,
    input        RegWrite,
    input        MemRead,
    input        MemWrite,
    input        ImmSelect,
    input        PCSelect,
    input        Jtype,
    input  [5:0] ALUSelect,

    output       RegWriteMasked,
    output       MemReadMasked,
    output       MemWriteMasked,
    output       ImmSelectMasked,
    output       PCSelectMasked,
    output       JtypeMasked,
    output [5:0] ALUSelectMasked
);

    assign RegWriteMasked    = FlushE ? 1'b0 : RegWrite;
    assign MemReadMasked     = FlushE ? 1'b0 : MemRead;
    assign MemWriteMasked    = FlushE ? 1'b0 : MemWrite;
    assign ImmSelectMasked   = FlushE ? 1'b0 : ImmSelect;
    assign PCSelectMasked    = FlushE ? 1'b0 : PCSelect;
    assign JtypeMasked       = FlushE ? 1'b0 : Jtype;
    assign ALUSelectMasked   = FlushE ? 6'd0 : ALUSelect;

endmodule
