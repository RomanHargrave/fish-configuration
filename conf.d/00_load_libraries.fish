begin
    set -l lib_dir (realpath (dirname (status -f))/../lib)

    for library in (find $lib_dir -type f -name '*.fish')
        source $library
    end
end
