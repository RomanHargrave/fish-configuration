function base16_decode
	perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie'
end
