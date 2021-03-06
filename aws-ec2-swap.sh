#!/bin/bash -e

[[ $DEBUG -gt 0 ]] && set -x || set +x


function usage () {
    printf "Setup swap file in given size.\n\n"

    printf "${0##*/}\n"
    printf "\t[-f]\n"
    printf "\t-s SIZE\n\n"

    printf "OPTIONS\n"
    printf "\t[-f]\n\n"
    printf "\tForce to recreate swap file if already exists one.\n\n"

    printf "\t-s SIZE\n\n"
    printf "\tSwap size in MB.\n\n"
    exit 255
}

function swap_file_is_exist () {
    test -e "$SWAP_FILE"
}

function swap_file_is_formated () {
    file "$SWAP_FILE" | grep -q 'swap file'
}

function swap_file_is_loaded () {
    swapon --noheadings --show=NAME | grep -q "$SWAP_FILE"
}


while getopts fs:h opt; do
    case $opt in
        f)
            force=1
            ;;
        s)
            size=$OPTARG
            ;;
        h|*)
            usage
            ;;
    esac
done

[[ -z $size ]] && usage

SWAP_FILE=/var/swap.1

if swap_file_is_exist; then
    if [[ $force -eq 1 ]]; then
        if swap_file_is_loaded; then
            /sbin/swapoff "$SWAP_FILE"
        else
            :
        fi
        /bin/rm -f "$SWAP_FILE"
    else
        echo "Swap file already exists, use -f to force recreate if needs."
        exit 255
    fi
fi

echo "creating swap file"
/bin/dd if=/dev/zero of="$SWAP_FILE" bs=1M count=$size
/bin/chmod 600 "$SWAP_FILE"

echo "formating swap file"
/sbin/mkswap "$SWAP_FILE"

echo "enabling swap file"
/sbin/swapon "$SWAP_FILE"

echo "adding swap file to fstab"
sed -i "/$(basename "$SWAP_FILE")/d" /etc/fstab
echo "$SWAP_FILE none        swap    sw              0   0" >> /etc/fstab

/sbin/swapon -s

echo "done"

exit
