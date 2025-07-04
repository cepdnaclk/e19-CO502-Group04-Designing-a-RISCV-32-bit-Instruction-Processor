module Mux_3_by_1 (in1,in2,in3,select,out);

    input [31:0] in1, in2, in3;
    input [1:0] select;
    output [31:0] out;

    assign out = (select == 2'b00) ? in1 : (select == 2'b01) ? in2 : (select == 2'b10) ? in3 : 32'h00000000;

endmodule