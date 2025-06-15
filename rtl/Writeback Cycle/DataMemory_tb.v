module DataMemory_tb;

    reg clk, reset, MemWrite, MemRead;
    reg [31:0] read_address, Write_data;
    wire [31:0] MemData_out;

    DataMemory uut (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .read_address(read_address),
        .Write_data(Write_data),
        .MemData_out(MemData_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Testing DataMemory Module");
        $monitor("Time=%0t, Addr=%0d, Write=%h, ReadEn=%b, WriteEn=%b, Output=%h", 
                  $time, read_address, Write_data, MemRead, MemWrite, MemData_out);

        clk = 0;
        reset = 1;
        MemWrite = 0;
        MemRead = 0;
        read_address = 0;
        Write_data = 0;

        #10 reset = 0;

        // Write 0xABCD1234 to address 5
        #10 read_address = 5; Write_data = 32'hABCD1234; MemWrite = 1;

        // Disable write, enable read from address 5
        #10 MemWrite = 0; MemRead = 1;

        // Read from address 0 (should be zero)
        #10 read_address = 0;

        // Read from address 5 (should return ABCD1234)
        #10 read_address = 5;

        #10 $finish;
    end
endmodule
