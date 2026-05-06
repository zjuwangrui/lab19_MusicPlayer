`timescale 1ns / 1ps

module beater_tb;

    // 输入信号
    reg clk;
    reg ready;
    reg reset;
    
    // output declaration of module beater
    wire beat;
    
    beater #(
        .n            	(3  ),
        .counter_bits 	(2   ))
    u_beater(
        .clk   	(clk    ),
        .ready 	(ready  ),
        .reset 	(reset  ),
        .beat  	(beat   )
    );
    
    // 时钟：周期 10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 测试激励
    initial begin
        // 初始状态
        ready = 0;
        reset = 1;
        // 等待复位稳定
        repeat(3) @(posedge clk);
        reset = 0;

        // 测试1: ready=1，观察8个时钟周期的beat输出
        ready = 1;

        repeat(10) @(posedge clk);
        
        // 测试2: ready=0，停止计数，beat应为0
        ready = 0;
        repeat(5) @(posedge clk);
        
        // 测试3: 再次使能ready
        ready = 1;
        repeat(10) @(posedge clk);
        
        // 测试4: 短脉冲ready
        ready = 0;
        @(posedge clk);
        ready = 1;
        @(posedge clk);
        ready = 0;
        repeat(5) @(posedge clk);
        
        // 结束仿真
        //$finish();
        $stop();
    end
    
    // 生成 VCD 波形文件
    // initial begin
    //     $dumpfile("prj/vcd/beater.vcd");
    //     $dumpvars(0, beater_tb);
    // end
    
    // 监控信号变化
    initial begin
        $monitor("Time=%0t, clk=%b, ready=%b, q=%d, beat=%b", 
                  $time, clk, ready, u_beater.q, beat);
    end

endmodule