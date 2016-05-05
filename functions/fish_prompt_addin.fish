function fish_prompt_addin -a action func
    switch $action
        case r rm remove
            if contains $func $_fish_prompt_addins 
                set pa_index (contains -i -- $func $_fish_prompt_addins)
                set -e _fish_prompt_addins[$pa_index]
            else 
                return 1
            end
        case a add
            if not contains $func $_fish_prompt_addins
                set -g _fish_prompt_addins $_fish_prompt_addins $func
            end
    end
end

