function quickpk3
	set tempfile (mktemp)
    set dversion $argv[1]
    set name $argv[2]
    set url $argv[3]
    set category doom-maps
    set folder  $DOOMWADPATH/pwad/idk/
    switch $dversion
        case doom1
            set folder $DOOMWADPATH/pwad/doom
            set category doom1-maps
        case doom2
            set folder $DOOMWADPATH/pwad/doom2
            set category doom2-maps
        case plutonia
            set folder $DOOMWADPATH/pwad/plutonia
            set category plutonia-maps
        case tnt
            set folder $DOOMWADPATH/pad/tnt
            set category tnt-maps
        case heretic
            set folder $DOOMWADPATH/pwad/heretic
            set category heretic-maps
        case hexen
            set folder $DOOMWADPATH/pwad/hexen
            set category hexen-maps
    end
    echo "category: $category"\n"name: $name" > Info
    wget $url --output-document=$tempfile
    unzip $tempfile
    rm $tempfile
    mkpk3 $folder/(echo $name | sed 's/ /_/g') **
end
