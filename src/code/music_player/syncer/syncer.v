module syncer(
    input clk,
    input in,
    output out
);
    reg q1,q2;
    always @(posedge clk) begin
        q1 <= in;
        q2 <= q1;
    end
    assign out = (~q2 & q1);
endmodule