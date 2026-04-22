`timescale 1ns / 1ps

module timer_tb;

    // 测试信号
    reg clk;
    reg beat;
    reg [5:0] duration_to_load;
    reg timer_clear;
    wire timer_done;
    
    // 实例化被测模块
    timer uut (
        .clk(clk),
        .beat(beat),
        .duration_to_load(duration_to_load),
        .timer_clear(timer_clear),
        .timer_done(timer_done)
    );
    
    // 时钟生成：周期 10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 测试激励
    initial begin
        // 初始化
        beat = 0;
        duration_to_load = 6'd10;  // 计数到10
        timer_clear = 1;
        
        // 显示波形开始
        $display("=== Timer Test Start ===");
        $dumpfile("prj/vcd/timer.vcd");
        $dumpvars(0, timer_tb);
        
        // 等待几个时钟周期
        repeat(2) @(posedge clk);
        
        // 释放 timer_clear，开始计时
        timer_clear = 0;
        $display("Time=%0t: Timer started, duration=%0d", $time, duration_to_load);
        
        // 测试1：正常计数到 duration_to_load
        repeat(10) begin
            @(posedge clk);
            beat = 1;  // 每个时钟周期都 beat
            $display("Time=%0t: q=%0d, timer_done=%0d", $time, uut.q, timer_done);
        end
        
        // 停止 beat
        @(posedge clk);
        beat = 0;
        $display("Time=%0t: Beat stopped, q=%0d", $time, uut.q);
        
        // 等待几拍
        repeat(3) @(posedge clk);
        
        // 测试2：重新开始计时（timer_clear）
        timer_clear = 1;
        @(posedge clk);
        timer_clear = 0;
        duration_to_load = 6'd5;  // 改为计数到5
        $display("Time=%0t: Restart timer, new duration=%0d", $time, duration_to_load);
        
        // 继续计数
        repeat(6) begin
            @(posedge clk);
            beat = 1;
            $display("Time=%0t: q=%0d, timer_done=%0d", $time, uut.q, timer_done);
        end
        
        // 测试3：中间清零
        beat = 0;
        @(posedge clk);
        timer_clear = 1;
        @(posedge clk);
        timer_clear = 0;
        duration_to_load = 6'd8;
        beat = 1;
        $display("Time=%0t: Reset mid-way, duration=%0d", $time, duration_to_load);
        
        repeat(10) begin
            @(posedge clk);
            $display("Time=%0t: q=%0d, timer_done=%0d", $time, uut.q, timer_done);
        end
        
        // 测试4：边界条件 - duration_to_load = 1
        timer_clear = 1;
        @(posedge clk);
        timer_clear = 0;
        duration_to_load = 6'd1;
        beat = 1;
        $display("Time=%0t: Edge case - duration=1", $time);
        
        @(posedge clk);
        $display("Time=%0t: q=%0d, timer_done=%0d", $time, uut.q, timer_done);
        
        @(posedge clk);
        $display("Time=%0t: q=%0d, timer_done=%0d", $time, uut.q, timer_done);
        
        // 测试结束
        repeat(5) @(posedge clk);
        $display("=== Timer Test Complete ===");
        $finish;
    end
    
    // 监控 timer_done 变化
    always @(posedge timer_done) begin
        $display("Time=%0t: *** TIMER DONE ASSERTED ***", $time);
    end
    

endmodule