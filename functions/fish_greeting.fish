function fish_greeting -d "what's up, fish?"
  fortune -u  disclaimer knghtbrd  12% pratchett 18% bofh-excuses 20% off  | cowsay -W 100 -f dragon
  set_color $fish_color_autosuggestion[1]
  uname -npsr
  uptime
  set_color normal
end
