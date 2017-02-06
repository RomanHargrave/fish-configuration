# don't run this file

function tell_error
    set_color red
    echo $argv
    set_color normal
end

function tell_warning
    set_color orange
    echo $argv
    set_color normal
end

function tell_success
    set_color green
    echo $argv
    set_color normal
end

# Hook install & persistence

function insure_link -a node dest
    if [ -L $node ]
        set cdest (readlink $node)
        if [ $cdest != $dest ]
            tell_warning "updated"
            rm $node
            ln -s $dest $node
        else
            tell_success "exists"
        end
    else if [ -O $node -o -f $node ]
        tell_error "$node exists and isn't a link to $dest, please delete it before continuing"
        return 1
    else if ln -s $dest $node >/dev/null ^&1
        tell_success "installed"
    else
        tell_error "could not link $node"
    end
end

function insure_git_hooks
    set git_home (git rev-parse --git-dir)
    set repo_base (dirname $git_home)
    set hook_dir $git_home/hooks
    set mgmt_hooks $repo_base/.management/hooks

    printf "Check post-checkout hook: "
    insure_link $hook_dir/post-checkout $mgmt_hooks/generic-post.fish

    printf "Check post-merge hook: "
    insure_link $hook_dir/post-merge    $mgmt_hooks/generic-post.fish
end

# Repo init

function update_submodules
    printf "Update submodules: "
    if git submodule update --init --recursive >/dev/null ^&1
        tell_success OK
    else
        tell_error "Failed: $status"
    end
end

# Fisher init

function update_fisher
    set git_home (git rev-parse --git-dir)
    set repo_base (dirname $git_home)
    source $repo_base/functions/fisher.fish
    echo "Updating Plugins"
    fisher update 
end
