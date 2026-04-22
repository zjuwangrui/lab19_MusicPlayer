module mcu_controller(
    input wire clk,
    input wire reset,
    input play_pause,
    input next,
    input song_done,
    output reg play,
    output reg reset_play,
    output reg NextSong
);
    parameter RESET = 2'b00, PLAY = 2'b01, PAUSE = 2'b10, NEXT = 2'b11;
    // State register
    reg [1:0] state, next_state;
    always @(posedge clk) begin
        if (reset)
            state <= RESET;
        else
            state <= next_state;
    end

    //状态转换和输出逻辑
    always @(*) begin
        //默认输出
        play = 0;
        reset_play = 0;
        NextSong = 0;
        case (state)
            RESET: begin
                next_state = PAUSE; //初始状态为PAUSE，等待用户操作
                play = 0;
                NextSong = 0;
                reset_play = 1; //重置播放状态以准备第一首歌
            end
            PLAY: begin
                play = 1;
                NextSong = 0;
                reset_play = 0;
                if (play_pause)
                    next_state = PAUSE;
                else if (next)
                    next_state = NEXT;
                else if (song_done)
                    next_state = RESET;
                else
                    next_state = PLAY;
            end
            PAUSE: begin
                play = 0;
                NextSong = 0;
                reset_play = 0;
                if (play_pause)
                    next_state = PLAY;
                else if (next)
                    next_state = NEXT;
                else
                    next_state = PAUSE;
            end
            NEXT: begin
                play = 0;
                NextSong = 1;
                reset_play = 1; //重置播放状态以准备下一首歌
                next_state = PLAY; //切换到PLAY状态以自动播放下一首歌
            end
            default: next_state = RESET;
        endcase
    end
endmodule