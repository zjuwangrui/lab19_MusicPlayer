module judge(
    input [5:0] duration,
    input co,
    input clk,
    output  song_done
);
    reg song_done_raw;
    always @(posedge clk) begin
        if(co) begin
            song_done_raw <= 1'b1;
        end
        else if(duration == 6'b 000000) begin
            song_done_raw <= 1'b1;
        end
        else begin
            song_done_raw <= 1'b0;
        end
    end
    reg q;
    always @(posedge clk) begin
        q <= song_done_raw;
    end

    assign song_done = song_done_raw & ~q;
endmodule