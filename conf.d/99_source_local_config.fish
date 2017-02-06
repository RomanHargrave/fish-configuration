# Search local config file
set __fish_data_dir     $HOME/.config/fish/
set __fish_local_dir    $__fish_data_dir/conf.local.d

for config in $__fish_local_dir/*.fish
    source $config
end

