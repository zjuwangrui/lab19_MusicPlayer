module beater
#(
    parameter n = 3, // 计数器的最大值，即每n个时钟周期输出一个beat。分频比
    parameter counter_bits = 2 // 计数器的位宽，应该满足2^counter_bits >= n
)
(
    input clk,
    input ready,
    input reset,
    output beat
);
    reg [counter_bits-1:0] q;
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (ready) begin
            if(q == n-1) q <= 0;
            else      q <= q + 1;
        end
    end
    assign beat = (q == n-1) & ready;
endmodule