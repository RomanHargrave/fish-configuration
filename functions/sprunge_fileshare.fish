function sprunge_fileshare
    for f in $argv
        if set _url (tar c $f | xz -ev | base64 -w0 | sprunge 2>/dev/null )
            echo $f: $_url
        else
            echo $f: $status
        end
    end
end
