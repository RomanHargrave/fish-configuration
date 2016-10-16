function sprunge_fileget -a url -a out
    curl $url | base64 -d | xz -dv | tar xv
end

