
# not enough arguments
[ $# -lt 1 ] && _usage && exit 1

# long flags with no hyphens
[ $1 = 'list' -o $1 = 'ls' ] && _list_session_files && exit 0 ;
[ $1 = 'help' ] && _usage && exit 0 ;
[ $1 = 'version' ] && _print_version && exit 0 ;

# arguments parsing loop
while getopts ':hle:n:vc:o:d:-:' option; do
    case "$option" in
        h)
            _usage ; exit 0 ;;
        c)
            _link_session_file ;;
        d)
            _delete_session_file $OPTARG ;;
        e)
            EXAMPLE_FILE=$OPTARG ;;
        n)
            NEW_SESSION_FILE=$OPTARG ;;
        l)
            LOCAL_SESSION=1 ;;
        o)
            _open_session_file $OPTARG ; exit 0 ;;
        v)
            _print_version ; exit 0 ;;
        -)
            case "$OPTARG" in
                -list)
                    _list_session_files ; exit 0 ;;
                -help)
                    _usage ; exit 0 ;;
                -version)
                    _print_version ; exit 0 ;;
            esac ;;
        :)
            echo -e "Option -$OPTARG requires an argument." ; _usage ; exit 1 ;;
        *)
            echo "Invalid option" ; _usage ; exit 1 ;;
    esac
done

# let's create that session file
[ ! -z $NEW_SESSION_FILE ] && _new_session_file && exit 0
