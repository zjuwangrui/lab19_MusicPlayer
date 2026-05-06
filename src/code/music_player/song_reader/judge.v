module judge(
    input [5:0] duration,
    input co,
    input clk,
    output  song_done
);
    reg song_done_raw;
    always @(posedge clk) begin
        if(co) begin
            song_done_raw <= 1'b1;//音符播放完的时候认为音乐结束
        end
        else if(duration == 6'b 000000) begin
            song_done_raw <= 1'b1;//音符播放到reset的时候认为音乐结束
        end
        else begin
            song_done_raw <= 1'b0;
        end
    end
    reg q;
    always @(posedge clk) begin
        q <= song_done_raw;
    end

    assign song_done = song_done_raw & ~q;//将song_done_raw的脉冲宽度变成一个时钟周期
endmodule