function bl2_apply_change --argument change savefile
	set backup $savefile.before_mod
set tmpfile $savefile.mod_tmp
bl2-savefile -l -m $change $savefile $tmpfile
cp $savefile $backup
mv $tmpfile $savefile
end
