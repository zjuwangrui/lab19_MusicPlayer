module mcu(
    input clk,
    input reset,
    input play_pause,
    input next,
    input song_done,
    output play,
    output reset_play,
    output [1:0] song
);
    // output declaration of module controller

    wire NextSong;
    
    mcu_controller #(
        .RESET 	(2'b00  ),
        .PLAY  	(2'b01  ),
        .PAUSE 	(2'b10  ),
        .NEXT  	(2'b11  ))
    u_controller(
        .clk        	(clk         ),
        .reset      	(reset       ),
        .play_pause 	(play_pause  ),
        .next       	(next        ),
        .song_done  	(song_done   ),
        .play       	(play        ),
        .reset_play 	(reset_play  ),
        .NextSong   	(NextSong    )
    );
    
    // output declaration of module counter
    
    mcu_counter u_counter(
        .clk   	(clk    ),
        .en    	(NextSong     ),
        .reset 	(reset  ),
        .q     	(song      )
    );
    
endmodule