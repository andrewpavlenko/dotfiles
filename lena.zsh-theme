# Minimal zsh theme
# Requires Font Awesome icons patched font

# Configuration
decoration="%(?:%F{red}%F{magenta}%F{cyan}%f :%F{red}%f )"
num_dirs=2 # Use 0 for full path
truncated_path="%{$fg_bold[white]%}%$num_dirs~%{$reset_color%} "
background_jobs="%(1j.%F{blue} %f .)"

PROMPT='$truncated_path$background_jobs$(git_prompt_info)$decoration'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%} ✘"
# Input in bold
zle_highlight=(default:bold)
# Enable syntax highlight for this file
# vim:ft=sh
