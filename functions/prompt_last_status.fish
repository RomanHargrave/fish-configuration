function prompt_last_status
	switch $status
case 0
set_color green
case '*'
set_color red
end
printf $status
end
