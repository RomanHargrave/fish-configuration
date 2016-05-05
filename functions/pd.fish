function pd
	if [ (count $argv) -gt 0 ]
		pushd $argv
	else
		popd
	end
end
