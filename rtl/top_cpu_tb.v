`timescale 1ns/1ps

module top_cpu_tb;

    reg clk;
    reg reset;

    // Instantiate the CPU
    top_cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Waveform dump for GTKWave
    initial begin
        $dumpfile("top_cpu.vcd");
        $dumpvars(0, top_cpu_tb);
    end

    // Simulation control
    initial begin
        reset = 1;
        #20;
        reset = 0;

        repeat (20) begin
            @(posedge clk);
            display_state();
        end

        $finish;
    end

    // Display task
    task display_state;
        integer i;
        begin
            $display("=== Cycle %0t ===", $time);
            $display("Register File:");
            for (i=0; i<32; i=i+1) begin
                $display("x%0d = 0x%08h", i, uut.decode_cycle_Imp.Reg_File_D.reg_array[i]);
            end
            $display("Data Memory:");
            for (i=0; i<16; i=i+1) begin
                $display("Mem[%0d] = 0x%08h", i, uut.Mem_cycle_Imp.DataMemoryMem.D_Memory[i]);
            end
            $display("========================");
        end
    endtask

endmodule
