set fish_greeting

set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
set -gx EDITOR "nvim"

abbr -a mirrors 'sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'

function mirrorcheck
    echo "🔍 Top mirrors"
    head -n 10 /etc/pacman.d/mirrorlist | grep Server
end

fish_add_path ~/.local/bin
fish_add_path ~/.nix-profile/bin
fish_add_path ~/.bun/bin
fish_add_path ~/.npm-global/bin

set -Ux CHROME_EXECUTABLE helium-browser
fish_add_path ~/SDKs/flutter/bin
fish_add_path ~/.config/composer/vendor/bin

alias ps 'procs'
alias cat 'bat'
alias aigoo 'nvim'
alias turu 'opencode'
alias wok 'zellij attach --create wok'

zoxide init fish | source

starship init fish | source

# opencode
fish_add_path /home/albetnv/.opencode/bin

mise activate fish | source
