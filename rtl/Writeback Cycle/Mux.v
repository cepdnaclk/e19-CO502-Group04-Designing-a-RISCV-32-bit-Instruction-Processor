module Mux(select, A, B, Mux_out);
    input select;
    input [31:0] A, B;
    output [31:0] Mux_out;

    assign Mux_out = (select == 1'b1) ? A : B;
endmodule
