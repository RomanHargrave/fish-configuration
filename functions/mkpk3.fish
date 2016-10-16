function mkpk3
    set pk3name         $argv[1]; set -e argv[1]
    set wadfiles        (printf '%s\n' $argv | grep -Ei '\.wad$')
    set wadfilenames    (printf '%s\n' $wadfiles | sed -r 's/\.wad$//gi')

    if count $wadfiles >/dev/null 
        for wad in $wadfiles 
            glbsp -y -q -p $wad 
        end 
    end

    zip -m $pk3name.pk3 $argv $wadfilenames.gwa
end

