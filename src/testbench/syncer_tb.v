// tb_syncer.v
// Testbench for syncer module (edge detection / pulse generator)
// Function: synchronizes input and outputs a single-cycle pulse on rising edge

`timescale 1ns / 1ps

module syncer_tb();

    // Testbench signals
    reg clk;
    reg in;
    wire out;
    
    // Instantiate the module under test (MUT)
    syncer uut (
        .clk(clk),
        .in(in),
        .out(out)
    );
    
    // Clock generation: 100 MHz clock (period = 10 ns)
    always #5 clk = ~clk;
    
    // VCD dump for waveform viewing
    initial begin
        $dumpfile("prj/vcd/syncer_tb.vcd");
        $dumpvars(0, syncer_tb);
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        in = 0;
        
        // Display test info
        $display("========================================");
        $display("Syncer Module Testbench");
        $display("Function: Rising edge detection with single-cycle pulse output");
        $display("========================================\n");
        
        // Wait for initial stabilization
        #20;
        
        // Test 1: Single short pulse (width < 1 clock cycle)
        $display("Test 1: Short pulse (15 ns wide, < 1 clock cycle)");
        @(posedge clk) #2;
        in = 1;
        #15;
        in = 0;
        #50;
        
        // Test 2: Single long pulse (width > 2 clock cycles)
        $display("\nTest 2: Long pulse (85 ns wide, > 2 clock cycles)");
        @(posedge clk) #2;
        in = 1;
        #85;
        in = 0;
        #50;
        
        // Test 3: Pulse exactly 1 clock cycle
        $display("\nTest 3: Exactly 1 clock cycle pulse (10 ns)");
        @(posedge clk) #2;
        in = 1;
        #10;
        in = 0;
        #50;
        
        //$finish;
        $stop();
    end

    
endmodule