# fish checksums library
# 
# Manage file checksums for collections of files

# Exit if a library cannot be found
set fish_require_fatal

require logging
require getopts
require fstools

set -q __integ_checksum_file_name;  or set -gx __integ_checksum_file_name ".checksum_cache"

function __has_bin -a name
    which $name >/dev/null
end

# Selects the best available hashing utility based on tests I performed
# In the order of most robust and speed
#
# Speed tests were performed using the following format:
#
#   for n in (seq 500)
#       dd if=/dev/urandom count=8 ^/dev/null | checksum_utility >/dev/null
#   end
#
# The above snippet was stored in a file `<utility_name>test.fish`. This file was then
# executed fifty times with the `time` utility and the output of `time` was piped in to awk,
# which was used to average the time. This was done in the following fashion:
#
#   for n in (seq 5)
#       time --format=%e fish ./<uility_name>test.fish
#   end | awk '{ sum += $1 } END { if ( NR > 0 ) print sum / NR }'
#
# That was used to to calculate the following:
#
# sha384sum     0.953
# sha512sum     0.9538
# sha224sum     0.9834
# md5sum        0.9834
# sha256sum     1.0204
# sha1sum       1.0442
function __integ_best_utility -d 'Locate a hash/checksum utility'
   if __has_bin sha384sum
       echo sha384sum
   else if __has_bin sha512sum
       echo sha512sum
   else if __has_bin sha224sum
       echo sha224sum
   else if __has_bin md5sum
       echo md5sum
   else if __has_bin sha256sum
       echo sha256sum
   else if __has_bin sha1sum
       echo sha1sum
   else
       echo "Could not find an appropriate hashing utility" 1>&2
       status -i; or exit 1
   end
end

function __integ_run_util
    eval (__integ_best_utility) $argv
end

function __integ_hash_files -d 'Create a hash for a file'
    set __utility_name (__integ_best_utility)
    if [ "x$__utility_name" != "x" ]
        __integ_run_util $argv
    else
        return 1
    end
end

function __integ_hash_format -d 'Create a hash storage file' -a utility_name
    echo $utility_name
    cat
end

function __integ_file_get_method -d 'Get the method used to create the checksum file' -a file_name
    head -n1 $file_name
end

function __integ_file_get_body -d 'Get the body of a checksum file' -a file_name
    tail -n +2 $file_name
end

function __integ_verify_hash_file -d 'Verify a hash file with the marked utility, if available' -a file_name
    set __utility_name (__integ_file_get_method $file_name)
    if __has_bin $__utility_name
        __integ_file_get_body $file_name | __integ_run_util -c - ^/dev/null
    else
        echo "Utility $__utility_name is not available" 1>&2
        return 1
    end
end

function __files_gen_checksum -d 'Create a checksum file'
    set __hash_status 0
    begin
       __integ_hash_files $argv 
       set __hash_status $status 2>&1 >/dev/null
    end | __integ_hash_format
    return $__hash_status
end

function __store_path -a base_dir
    echo "$base_dir/$__integ_checksum_file_name"
end

function __store_create_or_update -a base_dir utility
    set __store (__store_path $base_dir)
    if not [ -f $__store ]
        __integ_hash_format $utility > $__store
    else
        cat >> $__store
    end
end

function __integ_extract_ok
    grep -Po '.*(?=: OK$)'
end

function __integ_extract_failed
    grep -Po '.*(?=: FAILED$)'
end

function __integ_extract_checksum
    cut -d ' ' -f1
end

################################################################################################################

function file_get_known_checksum -d 'Get a stored file checksum' -a base_dir file_name
    set __store_path (__store_path $base_dir)
    if [ -f $__store_path ]
        set __checksums     (grep " $file_name\$" $__store_path | __integ_extract_checksum)
        set __n_checksums   (count $__checksums)
        if [ $__n_checksums -gt 1 ]
            echo "More than one checksum for $file_name" 1>&2
            return 2
        else if [ $__n_checksums -lt 1 ]
            return 1
        else
            echo $__checksums
        end
    else
        return 1
    end
end

function store_get_files -a base_dir
    set __store (__store_path $base_dir)
    __integ_file_get_body $__store | cut -d ' ' -f2-
end

function store_get_entries
    set -l base_dir $argv[1]; set -e argv[1]
    set __store (__store_path $base_dir)
    for criteria in $argv
        grep -P $criteria $__store
    end
end

function store_contains_file -a base_dir file_name
    set __store (__store_path $base_dir)
    if [ -f $__store ]
        count (grep " $file_name\$" $__store) >/dev/null
    else
        return 1
    end
end

function checksum_get_filename -a base_dir checksum
    set __store (__store_path $base_dir)
    if [ -f $__store_path ]
        grep "^$checksum" $__store | cut -d ' ' -f2-
    else
        return 1
    end
end

function store_remove_checksum -a base_dir checksum
    set __store (__store_path $base_dir)
    if [ -f $__store ]
        sed -i "/^$checksum/d" $__store
    else
        return 1
    end
end

function store_checksum -d 'Add a file checksum to the store' -a base_dir file_name
    set __relativised (rel_path $base_dir $file_name)
    pushd $base_dir
    set __checksum  (__integ_hash_files $__relativised)
    popd
    set __store     (__store_path       $file_name)
    store_remove_checksum $base_dir $__checksum
    echo $__checksum | __store_create_or_update $base_dir (__integ_best_utility) 
end

function store_list_changed -a base_dir
    set __store (__store_path $base_dir)
    pushd $base_dir
    __integ_verify_hash_file $__store | __integ_extract_failed
    popd
end

function store_list_unchanged -a base_dir
    set __store (__store_path $base_dir)
    pushd $base_dir
    __integ_verify_hash_file $__store | __integ_extract_ok
    popd
end

function verify_hash_files -d 'Check hash files'
    for file in $argv
        __integ_verify_hash_file $file > /dev/null
        or return 1
    end
    return 0
end

function check_file_hash -a base_dir file_name
    if store_contains_file $base_dir $file_name
        set __entries   (store_get_entries $base_dir "$file_name\$")
        set __n_entries (count $__entries)
        if not [ $__n_entries -gt 1 ]
            echo $__entries | __integ_run_util -c - ^/dev/null >/dev/null
        else
            echo "More than one enty for $file_name" 1>&2
            return 1
        end
    else
        return 1
    end
end  

function get_new_files
    set -l base_dir $argv[1]; set -e argv[1]
    set __files (store_get_files $base_dir)
    for file in $argv
        contains -- $file $__files >/dev/null; or echo $file
    end
end
