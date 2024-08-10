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

starship init fish | source
