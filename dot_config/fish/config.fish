set fish_greeting

set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

abbr -a mirrors 'sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'

function mirrorcheck
    echo "🔍 Top mirrors"
    head -n 10 /etc/pacman.d/mirrorlist | grep Server
end

fish_add_path ~/.local/bin
fish_add_path ~/.nix-profile/bin
set -Ux CHROME_EXECUTABLE brave
fish_add_path ~/tools/flutter/flutter/bin

alias ps 'procs'
alias cat 'bat'
alias aigoo 'nvim'

zoxide init fish | source

starship init fish | source

# opencode
fish_add_path /home/albetnv/.opencode/bin

# pnpm
set -gx PNPM_HOME "/home/albetnv/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
/home/albetnv/.local/bin/mise activate fish | source


# Added by Antigravity CLI installer
set -gx PATH "/home/albetnv/.local/bin" $PATH
