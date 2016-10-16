function filebin -a file
    set curl_args   http://filebin.ca/upload.php -F key="ehRBNZwK5X9DVogfymj2uPfbMNw7e+8J"

    set response (
        if [ -f $file ]
            curl $curl_args -F file=@$file
        else if [ -d $file ]
            tar c $file/ | xz -v | curl $curl_args -F file=@-
        end
    ); or return $status

    if set rs (string match -r 'status:(.+)' $response)
        switch $rs[2]
            case fail error
                echo "FileBin error"
                echo $response
            case '*'
                echo "https://filebin.ca/$rs[2]/-"
        end
    else
        echo "error: $status"
    end


end

