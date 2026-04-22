module timer(
    input clk,
    input beat,
    input [5:0] duration_to_load,
    input timer_clear,
    output timer_done
);  
    reg [5:0] q;
    always @(posedge clk) begin
        if(timer_clear) begin
            q <= 0;
        end else if (beat) begin
            if( q == duration_to_load - 1) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
    assign timer_done = (q == duration_to_load - 1) & beat;
endmodule