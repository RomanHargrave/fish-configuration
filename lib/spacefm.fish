# Hacks to improve the SpaceFM scripting experience

function sfm_get_env -V fm_import
    echo $fm_import | cut -d ' ' -f2-
end

function __sfm_get_bash_array -V fm_import -a var_name
    echo "
    $fm_import
    printf '%s\n' \"\${"$var_name"[@]}\"
    " | bash
end

function __sfm_get_bash_var -V fm_import -a var_name
    echo "
    $fm_import
    echo \$$var_name
    " | bash
end

function __sfm_import_array -V fm_import
    for name in $argv
        set -g $name    (__sfm_get_bash_array $name)
    end
end

function __sfm_import_var   -V fm_import
    for name in $argv
        set -g $name    (__sfm_get_bash_var $name)
    end
end


function sfm_import -V fm_import
    # Files
    __sfm_import_var    fm_file
    __sfm_import_array  fm{,_panel{1,2,3,4}}_files fm_filenames

    # SpaceFM
    __sfm_import_var    fm_{pwd,panel,tab,desktop_{files,pwd},command,value,user,my_{task,window},cmd_{name,dir,data},tmp_dir}
    __sfm_import_array  fm_{pwd_tab,tab_panel,panel{1,2,3,4}_files,pwd_panel{,{1,2,3,4}_tab}}

    # Device Manager
    __sfm_import_var    fm{,_panel{1,2,3,4}}_device{,_{udi,mount_point,fstype,label,display_name,icon,nopolicy,is_{mounted,optical,table,floppy,removable,audiocd,dvd,blank,mountable}}}

    # Bookmarks
    __sfm_import_var    fm{,_panel{1,2,3,4}}_bookmark

    # Tasks
    __sfm_import_var    fm_task_{type,name,pwd,pid,command,id,window,plugin_dir}
end

# SpaceFM function implementations

function fm_randhex4 -d "generate a random 4-digit base16 number"
    printf '%04x' (math \((random) + (random)\) '%' 65535)
end

function fm_new_tmp -d "create a new temporary directory"
    __sfm_import_var fm_tmp_dir
    set __self      %self
    set __tmp_salt  $__self-(fm_randhex4)
    set __tmp_name  "$fm_tmp_dir/$__tmp_salt"
    if mkdir $__tmp_name
        echo $__tmp_name
    else
        echo "Could not create $__tmp_name" 1>&2
        exit 1
    end
end

function fm_edit -d "edit a file" -a file
    spacefm -s set edit_file $file
end

