# List utilities

set -g  __list_fs   \x1F
set -g  __list_rs   \x1E

function string_split
    set delimiter $argv[1]; set -e argv[1]
    echo $argv | sed "s/$delimiter/\n/g"
end

function list_join
    set delimiter $argv[1]; set -e argv[1]
    printf "%s$delimiter" $argv
end

function list_map
    set with $argv[1]; set -e argv[1]
    for element in $argv
        eval "$with '$element'"
    end
end

function list_uniq
    printf '%s\n' $argv | sort -u 
end

function __get_list_by_name -S -a name
    eval "printf '%s\n' \$$name"
end

function list_push -S
    set name $argv[1]; set -e argv[1]
    if set -q $name
        set $name $argv (__get_list_by_name $name)
    else
        # We can't declare in the parent scope, even without shadowing (because it's a different thing)
        return 1
    end
end

function list_append -S
    set name $argv[1]; set -e argv[1]
    if set -q $name
        set $name (__get_list_by_name $name) $argv
    else
        return 1
    end
end

function list_pop -S
    set name $argv[1]; set -e argv[1]
    if set -q $name
        __get_list_by_name $name'[1]'
        set -e $name'[1]'
    else
        return 1
    end
end

