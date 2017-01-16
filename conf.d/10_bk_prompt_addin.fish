# Watch PWD to check for bitkeeper dir entry on dir change

if isatty
    function -v PWD _bk_prompt.pwd_watcher
        if bk root >/dev/null ^/dev/null
            fish_prompt_addin add _bk_prompt.bk_status_seg
        else
            fish_prompt_addin rm _bk_prompt.bk_status_seg
        end
    end

    function _bk_prompt.bk_status_seg
        set description (bk describe)
        if string match -r '.+-dirty' $description >/dev/null
            set_color red
        else
            set_color green
        end
        printf 'bk:%s' $description
    end
end
