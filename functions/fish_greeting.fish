function fish_greeting -d "what's up, fish?"
  fortune off bofh-excuses perl   | cowsay -W 100 -f dragon
  set_color $fish_color_autosuggestion[1]
  uname -npsr
  uptime
  set_color normal
end
