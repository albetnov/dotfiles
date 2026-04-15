set fish_greeting

set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

abbr -a mirrors 'sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'

function mirrorcheck
    echo "🔍 Top mirrors"
    head -n 10 /etc/pacman.d/mirrorlist | grep Server
end

fish_add_path ~/.local/bin
fish_add_path ~/.nix-profile/bin
fish_add_path ~/.bun/bin

alias ps 'procs'
alias cat 'bat'
alias aigoo 'nvim'

zoxide init fish | source

starship init fish | source
