function pvm -d "PHP Version Manager (Session Isolated)"
    set -l PVM_SESSION_DIR "/tmp/pvm_$fish_pid"
    set -l PVM_BIN "$PVM_SESSION_DIR/bin"
    set -l FLAKE_DIR ~/.config/nix/phps

    # Helper function to normalize targets (e.g., "8.2" -> "php82", "81" -> "php81")
    set -l target (string replace -a "." "" "$argv[2]")
    if string match -q -r '^[0-9]+$' "$target"
        set target "php$target"
    end

    # ==========================================
    # COMMAND: list
    # ==========================================
    if test "$argv[1]" = "list"
        echo (set_color -o blue)"🐘 Available PHP Versions"(set_color normal)
        echo (set_color black; set_color -o)"----------------------------------------"(set_color normal)
        
        if test -x /usr/bin/php
            set -l sys_ver (/usr/bin/php -v | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
            echo "  "(set_color cyan)"System (pacman):"(set_color normal)" php $sys_ver"
        else
            echo "  "(set_color cyan)"System (pacman):"(set_color normal)" Not installed"
        end

        set -l nix_phps (ls ~/.nix-profile/bin/*-php 2>/dev/null)
        if test (count $nix_phps) -gt 0
            for p in $nix_phps
                set -l base_name (basename "$p")
                set -l ver (string replace -r -- '-php$' '' "$base_name")
                echo "  "(set_color yellow)"Nix Profile:"(set_color normal)"     $ver"
            end
        else
            echo "  "(set_color yellow)"Nix Profile:"(set_color normal)"     No custom versions installed"
        end
        echo (set_color black; set_color -o)"----------------------------------------"(set_color normal)
        return 0
    end

    # ==========================================
    # COMMAND: install
    # ==========================================
    if test "$argv[1]" = "install"
        if test -z "$target"
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Please specify a version (e.g., 'pvm install 82')."
            return 1
        end

        # VALIDATION: Prevent duplicate installation
        if test -e ~/.nix-profile/bin/"$target"-php
            echo (set_color yellow; set_color -o)"⚠ PVM:"(set_color normal)" "(set_color cyan)"$target"(set_color normal)" is already installed!"
            echo "Run "(set_color green)"pvm update "(string replace "php" "" "$target")(set_color normal)" if you want to pull the latest patch."
            return 0
        end

        # SECURITY WARNINGS
        set -l num_ver (string replace "php" "" "$target")
        
        if test "$num_ver" -le 81
            echo ""
            echo (set_color -b red; set_color white; set_color -o)" !!! DANGER: INSECURE PHP VERSION !!! "(set_color normal)
            echo (set_color red; set_color -o)"PHP $num_ver is fundamentally INSECURE and no longer receives security updates!"(set_color normal)
            echo (set_color red)"Installing for legacy compatibility only. Use at your own risk."(set_color normal)
            echo ""
            sleep 1.5 # Pause so the user actually reads the warning
        else if contains "$num_ver" 82 83
            echo ""
            echo (set_color -b yellow; set_color black; set_color -o)" ⚠ WARNING: EOL PHP VERSION "(set_color normal)
            echo (set_color yellow; set_color -o)"PHP $num_ver is EOL (End of Life). Consider moving to a newer runtime soon."(set_color normal)
            echo ""
            sleep 0.5
        end

        echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Installing "(set_color yellow)"$target"(set_color normal)" from flake..."
        nix profile add "$FLAKE_DIR#$target"

        if test $status -eq 0
            echo (set_color green; set_color -o)"✓ PVM:"(set_color normal)" Successfully installed $target!"
        else
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Installation failed. Does '$target' exist in your flake.nix?"
        end
        return $status
    end

    # ==========================================
    # COMMAND: update
    # ==========================================
    if test "$argv[1]" = "update"
        if test -z "$target"
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Specify a version to update (e.g., 'pvm update 81') or use 'all'."
            return 1
        end

        # VALIDATION: Prevent updating a non-existent package
        if test "$target" != "phpall"
            if not test -e ~/.nix-profile/bin/"$target"-php
                echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Cannot update "(set_color yellow)"$target"(set_color normal)" because it is not installed."
                return 1
            end
        end

        echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Pulling latest upstream changes..."
        nix flake update --flake "$FLAKE_DIR"

        if test "$target" = "phpall"
            echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Upgrading all PHP versions in Nix profile..."
            nix profile upgrade ".*php.*"
        else
            echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Upgrading "(set_color yellow)"$target"(set_color normal)" in Nix profile..."
            nix profile upgrade ".*$target.*"
        end

        if test $status -eq 0
            echo (set_color green; set_color -o)"✓ PVM:"(set_color normal)" Update complete!"
        else
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Update failed."
        end
        return $status
    end

    # ==========================================
    # COMMAND: remove
    # ==========================================
    if test "$argv[1]" = "remove"
        if test -z "$target"
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Please specify a version (e.g., 'pvm remove 82')."
            return 1
        end

        # VALIDATION: Prevent removing a ghost package
        if not test -e ~/.nix-profile/bin/"$target"-php
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Cannot remove "(set_color yellow)"$target"(set_color normal)" because it is not currently installed."
            return 1
        end

        echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Removing "(set_color yellow)"$target"(set_color normal)" from Nix profile..."
        nix profile remove ".*$target.*"

        if test $status -eq 0
            echo (set_color green; set_color -o)"✓ PVM:"(set_color normal)" Successfully removed $target."
        else
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Removal failed."
        end
        return $status
    end

    # ==========================================
    # COMMAND: unlink
    # ==========================================
    if test "$argv[1]" = "unlink"
        rm -rf "$PVM_SESSION_DIR"
        
        if set -l index (contains -i "$PVM_BIN" $PATH)
            set -e PATH[$index]
        end
        
        echo (set_color green; set_color -o)"✓ PVM:"(set_color normal)" Unlinked. Restored to default profile."
        return 0
    end

    # ==========================================
    # COMMAND: use
    # ==========================================
    if test "$argv[1]" = "use"
        if test -z "$argv[2]"
            if not test -f "composer.json"
                echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" No version provided and no composer.json found."
                return 1
            end
            
            set -l parsed (grep -i '"php"' composer.json | head -n 1 | grep -oE '[0-9]+\.[0-9]+' | head -n 1 | tr -d '.')
            
            if test -z "$parsed"
                echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" Could not extract PHP version from composer.json."
                return 1
            end
            
            set target "php$parsed"
            echo (set_color blue; set_color -o)"ℹ PVM:"(set_color normal)" Found composer.json -> targeting "(set_color yellow; set_color -o)"$target"(set_color normal)
        end

        # VALIDATION: Hint to install if missing
        if not test -e ~/.nix-profile/bin/"$target"-php
            echo (set_color red; set_color -o)"✗ PVM Error:"(set_color normal)" "(set_color yellow)"$target"(set_color normal)" is not installed."
            echo "Run "(set_color cyan; set_color -o)"pvm install "(string replace "php" "" "$target")(set_color normal)" to download and install it."
            return 1
        end

        rm -rf "$PVM_SESSION_DIR"
        mkdir -p "$PVM_BIN"

        for bin_path in ~/.nix-profile/bin/"$target"-*
            set -l base_name (basename "$bin_path")
            set -l original_name (string replace -r "^$target-" "" "$base_name")
            ln -s "$bin_path" "$PVM_BIN/$original_name"
        end

        if not contains "$PVM_BIN" $PATH
            set -gx PATH "$PVM_BIN" $PATH
        end

        echo (set_color green; set_color -o)"✓ PVM:"(set_color normal)" Successfully switched to "(set_color yellow; set_color -o)"$target"(set_color normal)"!"
        echo (set_color black; set_color -o)"----------------------------------------"(set_color normal)
        php -v | head -n 1
        echo (set_color black; set_color -o)"----------------------------------------"(set_color normal)
        return 0
    end

    # ==========================================
    # HELP MENU (Fallback)
    # ==========================================
    echo (set_color -o blue)"🐘 PVM (PHP Version Manager)"(set_color normal)
    echo "Usage:"
    echo "  "(set_color yellow)"pvm list"(set_color normal)"            (Show installed PHP versions)"
    echo "  "(set_color yellow)"pvm install [ver]"(set_color normal)"   (Install from flake. e.g., 'pvm install 81')"
    echo "  "(set_color yellow)"pvm update [ver]"(set_color normal)"    (Fetch upstream updates. Use 'all' for all versions)"
    echo "  "(set_color yellow)"pvm remove [ver]"(set_color normal)"    (Remove from Nix profile. e.g., 'pvm remove 81')"
    echo "  "(set_color yellow)"pvm use [ver]"(set_color normal)"       (Switch runtime. If empty, reads composer.json)"
    echo "  "(set_color yellow)"pvm unlink"(set_color normal)"          (Restores default System/Nix behavior)"
end
