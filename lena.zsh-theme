# Minimal zsh theme
# Requires Font Awesome icons patched font

# Configuration
bg_jobs="%(1j..)"
decoration="%(?:%F{red}%F{magenta}%F{cyan}%F{blue}$bg_jobs%f :%F{red}$bg_jobs%f )"
num_dirs=2 # Use 0 for full path
truncated_path="%F{white}%$num_dirs~%f "

PROMPT='$truncated_path$background_jobs$(git_prompt_info)$decoration'

PL_BRANCH_CHAR=$'\ue0a0' # 
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}$PL_BRANCH_CHAR "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%} ✘"
# Input in bold
zle_highlight=(default:bold)
