function mkcd --description "Create and enter a directory" -a 'name'
	if mkdir $name
		cd $name
	else
		return $status
	end
end

