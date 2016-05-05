function __extract_short_mime
    mimetype -b $argv | cut -d / -f2-
end

function extract -d 'extract archives by mime type'
    for arch in $argv
        set __type (__extract_short_mime $arch)

        switch $__type
            case x-gzip gzip
                gunzip $arch
            case x-lzop
                lzop -x $arch
            case x-xz
                xz -d $arch
            case x-lzip
                lzip -d $arch
            case x-bzip x-bzip2
                if which bunzip > /dev/null
                    bunzip $arch
                else
                    bunzip2 $arch
                end
            case x-compress
                switch (get_extension $arch)
                    case z
                        unpack $arch
                    case Z
                        uncompress $arch
                end
            case x-alz-compressed
                unalz $arch
            case x-arj
                arj x $arch
            case x-lzh x-lzx x-apple-diskimage
                # Unrar supposedly knows these formats
                unrar x $arch 
            case x-rar-compressed
                unrar x $arch
            case x-shar
                exec $arch
            case java-archive
                if which jar > /dev/null
                    jar xvf $arch
                else
                    unzip $arch
                end
            case x-ace-compressed
                unace e $arch
            case x-cpio
                cpio --extract $arch
            case vnd.ms-cab-compressed
                cabextract $arch
            case x-unix-archive x-deb
                ar x $arch
            case zip
                unzip $arch
            case x-7z-compressed
                7z x $arch
            case x-tar x-ustar '*-compressed-tar'
                tar xvf $arch
            case x-lz4
                lz4 -d $arch $arch"_decompressed"
        end
    end
end
