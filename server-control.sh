#!/bin/sh
#
# Initialize server environment in a tmux session.
# To attach session: tmux -S "SOCKET_PATH" attach -t "TARGET_SESSION"
# To detach session: ctrl-b ctrl-d
#
# See default.yml for examples of SOCKET_PATH and TARGET_SESSION.
#

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-S TIME] [-s] [-r TIME] [YAML]...
Control a nwserver environment running in a tmux session. YAML must be a
valid YAML file similar to default.yml, of max depth one level. If no
file is specified, default.yml is used if present.

    -h                display this help and exit
    -S TIME           stop nwserver. The argument must be either "now"
                      or "friendly", resulting in instant shutdown or
                      shutdown in 2 minutes, respectively
    -s                start nwserver
    -r TIME           restart nwserver. For argument description, see
                      -S
EOF
}

# read YAML file before parsing arguments (!# resolves to last argument)
if [ -f ${!#} ]; then
    YML_FILE=${!#}
elif [ -f "default.yml" ]; then
    YML_FILE="default.yml"
else
    show_help
    exit 1
fi

export $(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' $YML_FILE)

#printf 'server_directory=%s\nSOCKET_PATH=%s\nRUNSCRIPT=%s\nTARGET_SESSION=%s\nLeftovers:\n' "$server_directory" "$socket_path" "$runscript" "$target_session"
#printf '<%s>\n' "$@"

# verify paths
[ -d ${server_directory} ] || { echo "Cannot find directory $server_directory. Aborting."; exit 1; }
[ -x ${runscript} ] || { echo "Cannot find executable script $runscript. Aborting."; exit 1; }

exit

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
while getopts "hS:sr:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        S)  /bin/bash stop-server $OPTARG
            exit 0
            ;;
        s)  /bin/bash start-server
            exit 0
            ;;
        r)  /bin/bash stop-server $OPTARG
            /bin/bash start-server
            exit 0
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.
