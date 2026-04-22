module note_player(
    input clk,
    input reset,
    input play_enable,
    input [5:0] note_to_load,
    input [5:0] duration_to_load,
    input load_new_note,
    input sampling_pulse,
    input beat,
    output note_done,
    output [15:0] sample
);
    // output declaration of module DFF
    wire R;
    assign R = (~play_enable) | reset;
    wire [5:0] addr;
    wire load;

    DFF u_DFF(
        .clk   	(clk    ),
        .reset 	(R  ),
        .D     	(note_to_load      ),
        .EN    	(load     ),
        .Q     	(addr      )
    );
    
    // output declaration of module np_controller
    wire timer_clear;
    wire timer_done;

    np_controller #(
        .RESET 	(00  ),
        .LOAD  	(01  ),
        .DONE  	(10  ),
        .WAIT  	(11  ))
    u_np_controller(
        .clk           	(clk            ),
        .reset         	(reset          ),
        .load_new_note 	(load_new_note  ),
        .play_enable   	(play_enable    ),
        .timer_done    	(timer_done     ),
        .timer_clear   	(timer_clear    ),
        .load          	(load           ),
        .note_done     	(note_done      )
    );
    
    // output declaration of module timer
    
    
    timer u_timer(
        .clk              	(clk               ),
        .beat             	(beat              ),
        .duration_to_load 	(duration_to_load  ),
        .timer_clear      	(timer_clear       ),
        .timer_done       	(timer_done        )
    );
    
    // output declaration of module frequency_rom
    wire [19:0] dout;
    
    frequency_rom u_frequency_rom(
        .clk  	(clk   ),
        .dout 	(dout  ),
        .addr 	(addr  )
    );
    
    // output declaration of module DDS
    wire [21:0] K;
    assign K = {2'b0, dout};
    
    DDS #(
        .n 	(22  ))
    u_DDS(
        .clk              	(clk               ),
        .reset            	(R             ),
        .K                	(K                 ),
        .sampling_pulse   	(sampling_pulse    ),
        .sample           	(sample            ),
        .new_sample_ready 	(  )
    );
    
endmodule