# Show the timestamp for each entry of the history file
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S "

# Ensure the history file size and entry number is large
# enough to record years upon years of history
# 500 Million commands in total
export HISTFILESIZE=500000000
# 50 Million (default: 500) commands in one session
export HISTSIZE=50000000
