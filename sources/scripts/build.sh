while [ ! $# -eq 0 ]
    do
    case "$1" in
        --statics | -s)
            source $(dirname ${BASH_SOURCE[0]})/build-statics.sh
        ;;
        --vf | -vf)
            source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -f
        ;;
        --all | -a)
            source $(dirname ${BASH_SOURCE[0]})/build-statics.sh
            source $(dirname ${BASH_SOURCE[0]})/build-vf.sh -f
        ;;
    esac
    shift
done