function mapwacom --argument output
	xsetwacom --list devices | grep -Po '(?<=id: )\d+' | xargs -n1 -I@ xsetwacom --set @ MapToOutput $output
end
