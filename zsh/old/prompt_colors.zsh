# Default background color.
typeset -g POWERLEVEL9K_BACKGROUND= #8  #196 # 235 # 008 # 239

# OS identifier color.
# typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=255
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND= #091
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND= #231

# Transparent background.
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=

# Custom icon.
# typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='⭐'

# Default current directory color.
# typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
FOREGROUND_COLOR=14 # 231
typeset -g POWERLEVEL9K_DIR_FOREGROUND=$FOREGROUND_COLOR
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$FOREGROUND_COLOR
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$FOREGROUND_COLOR

# Unicode example
# typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '

# Execution time color.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=4 #248

# Some asdf colors or smth still in the .p10k file

# Ranger shell color.
typeset -g POWERLEVEL9K_RANGER_FOREGROUND=3 #178

COLOR_RIGHT=7 #14

# Vim shell indicator color.
typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=3 #34
# Colors for different levels of disk usage.
typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=$COLOR_RIGHT #35
typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=220
typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=160
# Thresholds for different levels of disk usage (percentage points).
typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
# If set to true, hide disk usage when below $POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL percent.
typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=false
# Custom icon.
# typeset -g POWERLEVEL9K_DISK_USAGE_VISUAL_IDENTIFIER_EXPANSION='⭐'

# RAM color.
typeset -g POWERLEVEL9K_RAM_FOREGROUND=$COLOR_RIGHT  # Show average CPU load over this many last minutes. Valid values are 1, 5 and 15.
typeset -g POWERLEVEL9K_LOAD_WHICH=5
# Load color when load is under 50%.
typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=$COLOR_RIGHT
# Load color when load is between 50% and 70%.
typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=178
# Load color when load is over 70%.
typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=166
  
typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=110
 
 ##################################[ context: user@hostname ]##################################
# Context color when running with privileges.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1 #178
# Context color in SSH without privileges.
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=7 #180
# Default context color (no privileges, no SSH).
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=7 #180

# Python virtual environment color.
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37

# Goenv color.
typeset -g POWERLEVEL9K_GOENV_FOREGROUND=37


# Public IP color.
typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=94

# VPN IP color.
typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=81

# Current time color.
typeset -g POWERLEVEL9K_TIME_FOREGROUND=6 #66
