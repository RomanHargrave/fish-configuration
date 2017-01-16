# Watch PWD to check for svn dir entry

if isatty
    function _svn_prompt.pwd_watcher -v PWD
        if svn info >/dev/null ^/dev/null
            fish_prompt_addin add _svn_prompt.svn_status_seg
        else
            fish_prompt_addin rm _svn_prompt.svn_status_seg
        end
    end
end

function _svn_prompt.svn_status_seg
    set description (svn info --show-item revision)
    set_color white
    printf 'svn:%s' $description
end
