# Locate and add optware to path
if test -d $LFIX/opt
    for folder in (find $LFIX/opt -maxdepth 3 -type d -name bin)
        if [ -n folder ]
            conf.padd (realpath $folder ^/dev/null)
        end
    end

    # for exe in (dirname (realpath (find $LFIX/opt/ -maxdepth 1 -type f -executable ^/dev/null) | sort | uniq) | tail -n+2)
    #     padd $exe
    # end
end
