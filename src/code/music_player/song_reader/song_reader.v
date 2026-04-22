module song_reader(
    input clk,
    input reset,
    input note_done,
    input play,
    input [1:0] song,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);  
    // output declaration of module counter
    wire [4:0] q;
    wire co;
    sr_counter u_counter(
        .clk   	(clk    ),
        .en    	(note_done     ),
        .reset 	(reset  ),
        .q     	(q      ),
        .co    	(co     )
    );
    
    // output declaration of module sr_controller
    
    sr_controller #(
        .RESET     	(00  ),
        .WAIT      	(01  ),
        .NEXT_NOTE 	(10  ),
        .NEW_NOTE  	(11  ))
    u_sr_controller(
        .clk       	(clk        ),
        .reset     	(reset      ),
        .note_done 	(note_done  ),
        .play      	(play       ),
        .new_note  	(new_note   )
    );
    
    // output declaration of module song_rom

    song_rom u_song_rom(
        .clk  	(clk   ),
        .dout 	({note,duration}  ),
        .addr 	({song,q}  )
    );
    
    // output declaration of module judge
    
    judge u_judge(
        .duration  	(duration   ),
        .co        	(co         ),
        .clk       	(clk        ),
        .song_done 	(song_done  )
    );
    
endmodule