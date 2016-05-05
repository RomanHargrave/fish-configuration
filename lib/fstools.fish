# fish library for working with paths
# Roman Hargrave <roman@hargrave.info>
#
# Makes things like stripping file extensions, following links, and manipulating paths less verbose

function rel_path -d 'Compute the path of argv[2..] relative to argv[1]'
    if set -q argv[1..2]
        set base $argv[1]; set -e argv[1]
        for path in $argv
            realpath --relative-to $base $path
        end
    else
        echo "A base path and at least one path must be provided" 1>&2
        return 1
    end
end

function get_extension -d 'Get the file extension from each argument'
    for name in $argv
        echo $name | grep -Po '(?<=\.)[^\.]+?$'
    end
end

function strip_extension -d 'Strip the file extension from each argument'
    for name in $argv
        echo $name | grep -Po '^.*(?=\.[^\.]+?)'
        or echo $name
    end
end
   
function change_name -d 'Wrapper for `mv` that takes only one full path' -a path new_name
    set container   (dirname $path)
    set new_file    "$container/$new_name"
    if [ -e $new_file ]
        echo "$new_file already exists" 1>&2
        return 1
    else
        mv $path $new_file
    end
end

function ls_directories -d 'List all directories immediately under a directory' -a dir
    find $dir -maxdepth 1 -type d | grep -v "^$dir\$"
end

function is_empty -d 'Determine if a directory is empty' -a dir
    if [ -d $dir ]
        not count (find $dir -maxdepth 1 ^/dev/null) >/dev/null
    else
        return 1
    end
end

function contains_files -d 'Determine if a directory contains files' -a dir
    if [ -d $dir ]
        count (find $dir -type f ^/dev/null) >/dev/null
    else
        return 1
    end
end

