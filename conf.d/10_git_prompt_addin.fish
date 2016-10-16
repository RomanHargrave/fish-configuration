# Watch PWD to check for git dir entry on dir change

if isatty
    function -v PWD _git_prompt.pwd_watcher
        if git rev-parse --git-dir >/dev/null ^/dev/null
            fish_prompt_addin add _git_prompt.git_status_seg
        else
            fish_prompt_addin rm _git_prompt.git_status_seg
        end
    end
end

function _git_prompt.git_status_seg
    set description (git describe --always --tag --dirty)
    if string match -r '.+-dirty' $description >/dev/null
        set_color red
    else
        set_color green
    end
    printf 'git:%s' $description
end
