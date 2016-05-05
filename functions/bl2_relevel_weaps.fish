function bl2_relevel_weaps --argument savefile
	set tempfile $savefile.mod_tmp
set backup $savefile.before_mod
bl2-savefile -l -m itemlevels $savefile $tempfile
cp $savefile $backup
cp $tempfile $savefile
rm $tempfile
end
