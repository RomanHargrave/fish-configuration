function midi-render --argument in out
	fluidsynth -a file -L 2 -r 48000 -o synth.cpu-cores=8 -nli -T oga -F $out ~/.local/var/doom/wads/addons/FluidR3_GM.sf2 $in
end
