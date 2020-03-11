while [ ! $# -eq 0 ]
    do
    case "$1" in
        --statics | -s)
            source $(dirname ${BASH_SOURCE[0]})/build-statics.sh
        ;;
        # --normal | -n)
        #     source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -n
        # ;;
        --full | -f)
            source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -f
        ;;
        --all | -a)
            source $(dirname ${BASH_SOURCE[0]})/build-statics.sh
            # source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -n
            source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -f
            
        ;;
    esac
    shift
done