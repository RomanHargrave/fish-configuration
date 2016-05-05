function rmpv --argument vid
	set output_file (mktemp -u)
youtube-dl -o $output_file $vid
mpv $output_file
rm $output_file
end
