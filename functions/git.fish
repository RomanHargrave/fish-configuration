function git -w git
	if which hub >/dev/null
		hub $argv
	else
	 	command git $argv
	end
end

