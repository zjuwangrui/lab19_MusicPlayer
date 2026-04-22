module mcu_counter(
    input clk,
    input en,
    input reset,
    output reg [1:0] q
);
always @(posedge clk) begin
    if (reset)
        q <= 2'b00;
    else if (en)
        q <= q + 1;
end
endmodule