if isatty

    set _fconfig_config_dir $HOME/.config/fish/conf.d 

    # Locate a config file
    function _fconfig._locate_file -a filename
        set _path $_fconfig_config_dir/$filename 
        if [ -f $_path ] 
            echo $_path
            return 0
        else 
            return 1
        end
    end

    # Reload a config file
    function _fconfig.reload 
        for filename in $argv
            if set _path (_fconfig._locate_file $filename)
                source $_path
            else
                echo "Couldn't find $filename"
            end
        end
    end

    # Edit a config file
    function _fconfig.edit
        if set _path (_fconfig._locate_file $filename)
            if editor $_path
                source $_path
            end
        else
            echo "Couldn't find $filename"
        end
    end

    function config
        set _action $argv[1]
        set -e argv[1]
        switch $_action
            case reload r
                _fconfig.reload $argv
            case edit e 
                _fconfig.edit $argv
        end
    end


    # Completion

    function _fconfig._complete.fconfig

    end

    function _fconfig._complete._list_configs
        find $_fconfig_config_dir -maxdepth 1 -type f -name '*.fish' | xargs -n1 basename 
    end

    function _fconfig._complete_subcommand
        complete -c config -f -a $argv 
    end

    function _fconfig._complete_config_command
        complete -f -a '(_fconfig._complete._list_configs)' -d 'Configuration File' -c $argv
    end
    
    _fconfig._complete_config_command _fconfig.edit 
    _fconfig._complete_config_command _fconfig.reload

    _fconfig._complete_subcommand reload -x -w _fconfig.reload --description "Reload configuration files"
    _fconfig._complete_subcommand edit -x -w _fconfig.edit --description "Edit a configuration file"

end
