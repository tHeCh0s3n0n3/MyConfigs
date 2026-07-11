yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    fi

    transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
        transcript_flag="--transcript-with-timestamps"
        shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
}

# --- [ BAT Configuration ] ----------------------------------------------------
# Check for 'bat' first, fallback to 'batcat' (Debian/Ubuntu environments)
if command -v bat >/dev/null 2>&1; then
    BAT_BIN="bat"
elif command -v batcat >/dev/null 2>&1; then
    BAT_BIN="batcat"
else
    BAT_BIN=""
fi

if [ -n "$BAT_BIN" ]; then
    
    # Strip formatting characters and pipe to bat using manpage syntax
    export MANPAGER="sh -c 'col -bx | $BAT_BIN -l man -p'"
    
    # Pass the -c flag to roff to ensure plain text output without backspaces
    export MANROFFOPT="-c"

    alias cat="$BAT_BIN"
fi

# --- [ EZA Configuration ] ----------------------------------------------------
if command -v eza >/dev/null 2>&1; then
    
    # Standard list with icons and intelligent colorization
    alias ls='eza -gh --git --icons=auto --color=auto'
    
    # Long list format
    alias ll='eza -lgh --git --icons=auto --color=auto'
    
    # Long list format including hidden files/directories
    alias la='eza -lagh --git --icons=auto --color=auto'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# --- [ Docker Configuration ] ----------------------------------------------------
if command -v docker >/dev/null 2>&1; then
    
    # Standard docker ps
    alias dockerps='sudo docker ps'
    
    # Pretty docker ps
    alias dps='sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Command}}"'
fi
