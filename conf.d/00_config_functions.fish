# Shell helpers
function _gen_path_helper -a name varname
    eval 'function '$name';'\
        'for spec in $argv;'\
            'if not contains $spec $'$varname';'\
                'set -gx '$varname' $'$varname' $spec;'\
            'end;'\
        'end;'\
    'end;'
end

_gen_path_helper conf.padd          PATH
_gen_path_helper conf.ldadd         LD_LIBRARY_PATH
_gen_path_helper mark_exportable    fish_export_colons
_gen_path_helper pkg-config-add     PKG_CONFIG_PATH

functions -e _gen_path_helper
