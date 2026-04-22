module sr_counter(
    input clk,
    input en,
    input reset,
    output reg [4:0] q,
    output co
);
    assign co = (q == 5'b11111) & en;
always @(posedge clk) begin
    if (reset)
        q <= 5'b00000;
    else if (en)
        q <= q + 1;
end
endmodule