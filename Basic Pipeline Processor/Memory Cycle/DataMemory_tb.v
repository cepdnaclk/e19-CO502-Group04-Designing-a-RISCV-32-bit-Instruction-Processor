`timescale 1ns / 1ps

module DataMemory_tb();

    // Inputs
    reg clk;
    reg reset;
    reg MemWrite;
    reg MemRead;
    reg [31:0] read_address;
    reg [31:0] Write_data;

    // Outputs
    wire [31:0] MemData_out;

    // Instantiate the DataMemory module
    DataMemory uut (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .read_address(read_address),
        .Write_data(Write_data),
        .MemData_out(MemData_out)
    );
    
    // Waveform dump setup
	initial begin
	    $dumpfile("dump.vcd");
	    $dumpvars(0, DataMemory_tb);
	end


    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1;
        MemWrite = 0;
        MemRead = 0;
        read_address = 0;
        Write_data = 0;

        // Wait for two clock cycles
        @(posedge clk);
        @(posedge clk);
        reset = 0; // Release reset

        // Check reset clears memory by reading from address 0
        MemRead = 1;
        read_address = 0;
        @(posedge clk);
        if(MemData_out !== 32'b0) begin
            $display("Test failed: Memory not cleared on reset at address 0.");
            $stop;
        end else begin
            $display("Reset test passed at address 0.");
        end

        // Write data 0xDEADBEEF at address 10
        MemWrite = 1;
        MemRead = 0;
        read_address = 10;
        Write_data = 32'hDEADBEEF;
        @(posedge clk);

        // Disable write and enable read at address 10
        MemWrite = 0;
        MemRead = 1;
        @(posedge clk);

        // Check if data read matches written data
        if(MemData_out !== 32'hDEADBEEF) begin
            $display("Test failed: Memory read data mismatch at address 10. Got %h", MemData_out);
            $stop;
        end else begin
            $display("Write and read test passed at address 10.");
        end

        // Write at another address 20 with data 0x12345678
        MemWrite = 1;
        MemRead = 0;
        read_address = 20;
        Write_data = 32'h12345678;
        @(posedge clk);

        // Read from address 20 and verify
        MemWrite = 0;
        MemRead = 1;
        @(posedge clk);
        if(MemData_out !== 32'h12345678) begin
            $display("Test failed: Memory read data mismatch at address 20. Got %h", MemData_out);
            $stop;
        end else begin
            $display("Write and read test passed at address 20.");
        end

        // Read from an unwritten address 30, should be zero
        read_address = 30;
        @(posedge clk);
        if(MemData_out !== 32'b0) begin
            $display("Test failed: Expected 0 at unwritten address 30 but got %h", MemData_out);
            $stop;
        end else begin
            $display("Read from unwritten address test passed.");
        end

        // Disable MemRead, check output is zero
        MemRead = 0;
        @(posedge clk);
        if(MemData_out !== 32'b0) begin
            $display("Test failed: Expected 0 when MemRead=0 but got %h", MemData_out);
            $stop;
        end else begin
            $display("MemRead disable test passed.");
        end

        $display("All tests passed.");
        $stop;
    end

endmodule

