function fish_title
  echo $_ ' '
  pwd | sed s_\^"$HOME"_\~_gi
end
