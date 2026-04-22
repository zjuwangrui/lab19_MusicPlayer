`timescale 1ns / 1ps

module judge_tb;

    // 输入信号
    reg [5:0] duration;
    reg co;
    reg clk;
    
    // 输出信号
    wire song_done;
    
    // 实例化待测模块
    judge u_judge (
        .duration(duration),
        .co(co),
        .clk(clk),
        .song_done(song_done)
    );
    
    // 时钟信号：周期 10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 5ns 翻转，周期10ns
    end
    
    // 测试激励
    initial begin
        // 初始化
        duration = 6'b000000;
        co = 1'b0;
        
        // 等待几个时钟周期
        repeat(3) @(posedge clk);
        
        // 测试1: duration为0，song_done应为1
        duration = 6'b000000;
        co = 1'b0;
        repeat(2) @(posedge clk);
        
        // 测试2: duration非0，co=0，song_done应为0
        duration = 6'b001010;  // 十进制10
        co = 1'b0;
        repeat(2) @(posedge clk);
        
        // 测试3: co=1，song_done应为1
        duration = 6'b001010;
        co = 1'b1;
        repeat(2) @(posedge clk);
        
        // 测试4: co=0，duration非0，song_done应为0
        co = 1'b0;
        repeat(2) @(posedge clk);
        
        // 测试5: duration从非0变为0
        duration = 6'b000000;
        repeat(2) @(posedge clk);
        
        // 结束仿真
        repeat(5) @(posedge clk);
        $finish();
    end
    
    // 打印波形信息（可选）
    initial begin
        $dumpfile("judge.vcd");
        $dumpvars(0, judge_tb);
    end
    
    // 监控信号变化（可选，用于调试）
    initial begin
        $monitor("Time=%0t, duration=%b, co=%b, song_done=%b", 
                  $time, duration, co, song_done);
    end

endmodule