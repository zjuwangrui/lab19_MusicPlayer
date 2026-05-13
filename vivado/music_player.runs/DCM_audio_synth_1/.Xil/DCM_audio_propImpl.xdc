set_property SRC_FILE_INFO {cfile:d:/constructing_projects/FPGA_projects/FPGA_design_course/lab19_MusicPlayer/vivado/music_player.gen/sources_1/ip/DCM_audio/DCM_audio.xdc rfile:../../../music_player.gen/sources_1/ip/DCM_audio/DCM_audio.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
