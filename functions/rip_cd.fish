function rip_cd --argument name tracks
	cdrdao read-toc $name.toc
cueconvert $name.toc $name.cue
cdparanoia --sample-offset=6 --force-cdrom-device /dev/sr0 -S 1 $tracks $name.wav | tee $name.log
end
