function sprunge
	if test (count $argv) -gt 0
		cat $argv | sprunge
	else
		curl -F 'sprunge=<-' http://sprunge.us
	end
end
