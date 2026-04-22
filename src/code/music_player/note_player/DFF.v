module DFF(
    input clk,
    input reset,
    input [5:0] D,
    input EN,
    output reg [5:0] Q 
);
    always @(posedge clk) begin
        if (reset) Q <= 6'b0;
        else if (EN) Q <= D;
    end
endmodule