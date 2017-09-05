# Hacks to improve the SpaceFM scripting experience

function sfm
   spacefm $argv
end

function ipc
   sfm -s $argv
end

function task
   set _do $argv[1]
   set -e argv[1]
   switch $_do
      case get
         ipc get-task $argv
      case set
         ipc set-task $argv
      case run
         ipc run-task $argv
   end
end

function task.await -a id
   while not task get $id status >/dev/null 2>&1
      sleep 0.2
   end
end

function sfm.extract_env -a _pfx
   cat | string replace -fra '(^'$_pfx'_[^=]+)=\'(.*)\'$' '$1%#fish_sfm#%$2'
end

function sfm.env_tuple
   string split '%#fish_sfm#%' "$argv"
end

function dialog
   set -l _pfx $argv[1]
   set -e argv[1]

   for rline in (spacefm -g --prefix $_pfx $argv 2>/dev/null | sfm.extract_env $_pfx)
      set pair (sfm.env_tuple $rline)
      set -g $pair[1] $pair[2]
   end
end

# SpaceFM environment wrangling

function sfm_get_env -V fm_import
    echo $fm_import | cut -d ' ' -f2-
end

function __sfm_get_bash_array -V fm_import -a var_name
    echo "
    $fm_import ;
    printf '%s\n' \"\${"$var_name"[@]}\"
    " | bash
end

function __sfm_get_bash_var -V fm_import -a var_name
    echo "
    $fm_import ;
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

   if set -q fm_my_task
      function this
         task $argv[1] $fm_my_task $argv[2..-1]
      end

      function this.await
         task.await $fm_my_task
      end
   end
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

