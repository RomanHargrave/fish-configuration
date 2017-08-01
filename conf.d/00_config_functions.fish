# Shell helpers
function conf._gen_path_helper -a name varname
    eval 'function '$name';'\
        'for spec in $argv;'\
            'if not contains $spec $'$varname';'\
                'set -gx '$varname' $'$varname' $spec;'\
            'end;'\
        'end;'\
    'end;'
end

conf._gen_path_helper conf.padd          PATH
conf._gen_path_helper conf.ldadd         LD_LIBRARY_PATH
conf._gen_path_helper mark_exportable    fish_export_colons
conf._gen_path_helper pkg-config-add     PKG_CONFIG_PATH
