module music_player
#(
    parameter sim = 0 // set to 1 for simulation, 0 for synthesis
)
(
    input clk,
    input reset,
    input next,
    input play_pause,
    input NewFrame,
    output [15:0] sample,
    output play,
    output [1:0] song
    );

    // output declaration of module mcu
    wire song_done;
    wire reset_play;
    
    mcu u_mcu(
        .clk        	(clk         ),
        .reset      	(reset       ),
        .play_pause 	(play_pause  ),
        .next       	(next        ),
        .song_done  	(song_done   ),
        .play       	(play        ),
        .reset_play 	(reset_play  ),
        .song       	(song        )
    );
    
    // output declaration of module song_reader
    wire note_done;
    wire [5:0] note;
    wire [5:0] duration;
    wire new_note;
    
    song_reader u_song_reader(
        .clk       	(clk        ),
        .reset     	(reset      ),
        .note_done 	(note_done  ),
        .play      	(play       ),
        .song      	(song       ),
        .song_done 	(song_done  ),
        .note      	(note       ),
        .duration  	(duration   ),
        .new_note  	(new_note   )
    );
    
    // output declaration of module note_player
    wire ready;
    wire beat;

    note_player u_note_player(
        .clk              	(clk               ),
        .reset            	(reset             ),
        .play_enable      	(play       ),
        .note_to_load     	(note      ),
        .duration_to_load 	(duration  ),
        .load_new_note    	(new_note     ),
        .sampling_pulse   	(ready    ),
        .beat             	(beat              ),
        .note_done        	(note_done         ),
        .sample           	(sample            )
    );
    
    // output declaration of module syncer
    
    syncer u_syncer(
        .clk 	(clk  ),
        .in  	(NewFrame   ),
        .out 	(ready  )
    );
    
    // output declaration of module beater
    
    beater #(
        .n            	(sim ? 64 : 1000) // set to 64 for simulation, 1000 for synthesis
        .counter_bits 	(sim ? 6 : 10) // set to 6 for simulation, 10 for synthesis)
    )
    u_beater(
        .clk   	(clk    ),
        .ready 	(ready  ),
        .reset 	(reset  ),
        .beat  	(beat   )
    );
    
endmodule