if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Setup brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# `ls` → `eza` abbreviation
# Requires `brew install eza`
if type -q eza
  abbr --add -g ls 'eza --long --classify --all --header --git --no-user --tree --level 1'
end

# `cat` → `bat` abbreviation
# Requires `brew install bat`
if type -q bat
  abbr --add -g cat 'bat'
end

# Set tty for GPG so that we can use 1password to sign the password
set -gx GPG_TTY (tty)

# Universal JVM flags — apply to all JVMs spawned from fish (JDTLS, Maven,
# Spring Boot, test forks). Only flags that are safe for every process type.
# GC and heap are configured per-process below or via .mvn/jvm.config.
set -gx JAVA_TOOL_OPTIONS "\
-XX:+UseStringDeduplication \
-XX:SoftRefLRUPolicyMSPerMB=50 \
-XX:ReservedCodeCacheSize=512m \
-XX:+SegmentedCodeCache"

# Maven build JVM — heap only, uses JDK default GC (G1GC on JDK 25).
set -gx MAVEN_OPTS "-Xmx2g"

starship init fish | source

# pnpm
set -gx PNPM_HOME "/Users/widgethiro/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx INTELLIJ_HOME "/Applications/IntelliJ IDEA.app/Contents/MacOS"
if not string match -q -- $INTELLIJ_HOME $PATH
  set -gx PATH "$INTELLIJ_HOME" $PATH
end

set -gx RANCHER_DESKTOP_HOME "/Users/widgethiro/.rd/bin"
if not string match -q -- $RANCHER_DESKTOP_HOME $PATH
  set -gx PATH "$RANCHER_DESKTOP_HOME" $PATH
end

# Added by Antigravity
fish_add_path /Users/widgethiro/.antigravity/antigravity/bin

export PATH="$HOME/.local/bin:$PATH"

# Auto-switch Node version on directory change.
# fish-nvm only auto-activates $nvm_default_version globally; this walks upward
# from $PWD looking for .nvmrc / .node-version, then defers to `nvm use` (which
# walks upward itself) so subdirs of a pinned project still activate.
function __auto_nvm_use --on-variable PWD
    status is-interactive; or return
    set -l dir $PWD
    while test -n "$dir" -a "$dir" != /
        if test -f "$dir/.nvmrc" -o -f "$dir/.node-version"
            nvm use --silent 2>/dev/null
            return
        end
        set dir (path dirname $dir)
    end
end
