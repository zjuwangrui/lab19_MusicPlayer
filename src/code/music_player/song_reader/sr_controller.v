module sr_controller(
    input wire clk,
    input wire reset,
    input wire note_done,
    input wire play,
    output reg new_note
);
    parameter RESET = 2'b00, WAIT = 2'b01, NEXT_NOTE = 2'b10, NEW_NOTE= 2'b11;
    reg [1:0] state, next_state;
    always @(posedge clk) begin
        if(reset) begin
            state <= RESET;
        end else begin
            state <= next_state;
        end
    end
    always @(*) begin
        new_note = 0;
        case(state)
            RESET: next_state = play? NEW_NOTE : RESET;
            WAIT: begin 
                if(play) begin
                    next_state = note_done? NEXT_NOTE : WAIT;
                end else begin
                    next_state = RESET;
                end
            end
            NEXT_NOTE: next_state = NEW_NOTE;
            NEW_NOTE: begin 
                next_state = WAIT;
                new_note = 1;
            end
        endcase
    end
endmodule