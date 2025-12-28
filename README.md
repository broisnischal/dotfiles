Mine dotfiles

xargs brew install < packages.txt

#### Auto Show/Hide Dock


<aside>
🔗 Paste the following commands into your terminal app
</aside>

keep smooth animation time, but remove delay:
`defaults write com.apple.dock autohide-delay -float 0; killall Dock`

instantly reveal:
`defaults write com.apple.dock autohide-time-modifier -int 0; killall Dock`

restore default behavior:
`defaults delete com.apple.dock autohide-delay; killall Dock`