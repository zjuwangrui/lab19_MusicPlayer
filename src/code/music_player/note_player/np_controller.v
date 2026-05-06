module np_controller(
    input clk,
    input reset,
    input load_new_note,
    input play_enable,
    input timer_done,
    output reg timer_clear,
    output reg load,
    output reg note_done
);
    parameter RESET = 2'b00, LOAD = 2'b01, DONE = 2'b10, WAIT = 2'b11;
    reg [1:0] state, next_state;
    always @(posedge clk) begin
        if(reset) state <= RESET;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            RESET: begin
                next_state = WAIT;
                timer_clear = 1;
                load = 0;
                note_done = 0;
            end
            LOAD: begin
                next_state = WAIT;
                timer_clear = 1;
                load = 1;
                note_done = 0;
            end
            WAIT: begin
                if(play_enable) begin
                    if(timer_done) begin
                        next_state = DONE;
                    end
                    else if(load_new_note) begin
                            next_state = LOAD;
                        end
                        else next_state = WAIT;
                end 
                else next_state = RESET;
                timer_clear = 0;
                load = 0;
                note_done = 0;
            end
            DONE: begin
                next_state = WAIT;
                timer_clear = 1;
                load = 0;
                note_done = 1;
            end
             default: begin
                next_state = RESET;
                timer_clear = 1;
                load = 0;
                note_done = 0;
            end
        endcase
    end
endmodule