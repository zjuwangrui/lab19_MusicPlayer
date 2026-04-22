module beater(
    input clk,
    input ready,
    input reset,
    output beat
);
    reg [2:0] q;
    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b0;
        end else if (ready) begin
            if(q == 3'd7) q <= 0;
            else      q <= q + 1;
        end
    end
    assign beat = (q == 3'd7) & ready;
endmodule