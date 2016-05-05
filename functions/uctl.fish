function uctl --wraps=systemctl
	systemctl --user $argv
end
