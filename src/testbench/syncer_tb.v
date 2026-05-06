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
        check_output("Test 1");
        
        // Test 2: Single long pulse (width > 2 clock cycles)
        $display("\nTest 2: Long pulse (85 ns wide, > 2 clock cycles)");
        @(posedge clk) #2;
        in = 1;
        #85;
        in = 0;
        #50;
        check_output("Test 2");
        
        // Test 3: Pulse exactly 1 clock cycle
        $display("\nTest 3: Exactly 1 clock cycle pulse (10 ns)");
        @(posedge clk) #2;
        in = 1;
        #10;
        in = 0;
        #50;
        check_output("Test 3");
        
        // Test 4: Back-to-back pulses with gap
        $display("\nTest 4: Back-to-back pulses with 2-cycle gap");
        @(posedge clk) #2;
        in = 1;
        #30;
        in = 0;
        #20;
        in = 1;
        #30;
        in = 0;
        #50;
        check_output("Test 4");
        
        // Test 5: Pulse followed immediately by another (no gap)
        $display("\nTest 5: Consecutive pulses (no gap between)");
        @(posedge clk) #2;
        in = 1;
        #30;
        in = 0;
        #0;  // Immediate next pulse
        in = 1;
        #30;
        in = 0;
        #50;
        check_output("Test 5");
        
        // Test 6: Very long pulse ( > 10 clock cycles)
        $display("\nTest 6: Very long pulse (250 ns)");
        @(posedge clk) #2;
        in = 1;
        #250;
        in = 0;
        #50;
        check_output("Test 6");
        
        // Test 7: Random input pattern
        $display("\nTest 7: Random input pattern");
        repeat(30) begin
            @(posedge clk);
            in = $random % 2;
        end
        #50;
        $display("Test 7 completed\n");
        
        // Test 8: Metastability / setup/hold violation (glitch test)
        $display("\nTest 8: Input change near clock edge (metastability simulation)");
        @(posedge clk);
        #3;  // 3 ns after posedge (slight setup violation)
        in = 1;
        #7;
        @(posedge clk);
        #4;  // 4 ns after posedge
        in = 0;
        #7;
        @(negedge clk);
        #2;
        in = 1;
        #50;
        $display("Test 8 completed - Check waveform for proper synchronization\n");
        
        // Test 9: Asynchronous reset-like behavior (input low for long time)
        $display("\nTest 9: Long idle period followed by pulse");
        @(posedge clk) #2;
        in = 0;
        #200;
        in = 1;
        #30;
        in = 0;
        #50;
        check_output("Test 9");
        
        // Test 10: Edge case - very short glitch (5 ns)
        $display("\nTest 10: Very short glitch (5 ns, < 1/2 clock cycle)");
        @(posedge clk) #2;
        in = 1;
        #5;
        in = 0;
        #50;
        $display("Test 10 completed - Glitch should be filtered\n");
        
        // End of tests
        #100;
        $display("========================================");
        $display("All tests completed");
        $display("Check tb_syncer.vcd for waveform analysis");
        $display("========================================");
        
        $finish;
    end
    
    // Task to check output behavior
    task check_output(input string test_name);
        begin
            #1;  // Small delay for signal settling
            if (out === 1'bx) begin
                $display("  [%0t] %s: WARNING - Output is X state", $time, test_name);
            end else begin
                $display("  [%0t] %s: Completed - out = %b", $time, test_name, out);
            end
        end
    endtask
    
    // Monitor important signals
    initial begin
        $monitor("Time = %0t ns | clk = %b, in = %b, q1 = %b, q2 = %b, out = %b",
                 $time, clk, in, uut.q1, uut.q2, out);
    end
    
    // Optional: Generate random test patterns automatically
    initial begin
        // Extra random test after all scheduled tests
        #800;
        $display("\nAdditional random testing for 400 ns...");
        repeat(40) begin
            @(posedge clk);
            in = $random;
        end
        #100;
        $display("Random test completed");
    end
    
endmodule