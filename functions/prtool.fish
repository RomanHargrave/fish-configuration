function __gradle_helper
    set action $argv[1]; set -e argv[1]
    set items_git build.gradle settings.gradle gradle gradlew gradlew.bat
    switch $action
        case git-add ga
            for item in $items_git
                if [ -e $PWD/$item ]
                    git add $argv $PWD/$item
                end
            end
        case git-del gd
            for item in $items_git
                if [ -e $PWD/$item ]
                    git rm $argv $PWD/$item
                end
            end
        case '*'
            echo "I don't know that command!"
    end
end

function __git_helper
    set action $argv[1]; set -e argv[1]
    switch $action
        case user u
            set name $argv[1]
            set mail $argv[2]
            git config --local user.name $name
            git config --local user.email $mail
        case '*'
            echo "I don't know that command!"
    end
end

function prtool
    set action $argv[1]; set -e argv[1]
    switch $action
        case gradle gr
            __gradle_helper $argv
        case git gi
            __git_helper $argv
        case '*'
            echo "I can't help you with that!"
    end
end

