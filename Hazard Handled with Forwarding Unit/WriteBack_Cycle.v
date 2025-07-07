module writeBack_cycle(RegWriteM, JtypeM, MemReadM, DataMemOutM, ALUOutM, ALUSelectM, WriteAddressM, RegWriteD, RegInDataD, WriteAddressD, RegWrite2FU, ResultOut2E, WriteAddress2FU);

    input [31:0] DataMemOutM, ALUOutM;
    input [5:0] ALUSelectM;
    input [4:0] WriteAddressM;
    input RegWriteM, JtypeM, MemReadM;
    output [31:0] RegInDataD, ResultOut2E;
    output [4:0] WriteAddressD, WriteAddress2FU;
    output RegWriteD, RegWrite2FU;

    wire [31:0] LoadConverterDataW, Load2AdderW, Adder2Mux;

    Mux Mux1(
        .select(MemReadM), 
        .A(DataMemOutM), 
        .B(ALUOutM), 
        .Mux_out(LoadConverterDataW)
    );

    LoadConverter LoadConverterW(
        .inputData(LoadConverterDataW),
        .aluSelect(ALUSelectM),
        .outputData(Load2AdderW)
    );

    Adder AdderW(
        .in_1(Load2AdderW), 
        .in_2(32'd4), 
        .Sum_out(Adder2Mux)
    );

    Mux Mux2(
        .select(JtypeM), 
        .A(Adder2Mux), 
        .B(Load2AdderW), 
        .Mux_out(RegInDataD)
    );

    assign WriteAddressD = WriteAddressM;
    assign RegWriteD = RegWriteM;
    assign RegWrite2FU = RegWriteD;
    assign WriteAddress2FU = WriteAddressM;
    assign ResultOut2E = LoadConverterDataW;

endmodule
