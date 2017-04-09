function strip-extension
	string match -ar '^.+(?=\..+)' $argv
end
