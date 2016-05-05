function mfdl -a link target
    if set file_loc (curl $link | grep -Po '(?<= ")http://download\d+\\.mediafire.com/.+(?=";)')
        echo "Found file at «$file_loc»" 1>&2
        wget $file_loc --output-document=$target
    else
        echo 'Could not extract a download link from the document!' 1>&2
    end
end

