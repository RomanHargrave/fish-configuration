function pactl_init_game
	pactl load-module module-null-sink sink_name=duplex_out
pactl load-module module-null-sink sink_name=game_out
pactl load-module module-loopback source=game_out.monitor
pactl load-module module-loopback source=game_out.monitor sink=duplex_out
pactl load-module module-loopback sink=duplex_out
end
