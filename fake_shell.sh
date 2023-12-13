#!/bin/bash

# Simple terminal to mock a network device for backup

sys_exit() {
    echo "Ctrl+C pressed. Exiting the script. Bye!"
    exit 0
}

# Trap Ctrl+C to call the ctrl_c function
trap sys_exit INT

while true; do
    # Terminal prompt; echo with `-n` option didn't work for some reason.
    printf "ROUTER# "

    # Read the user's input command.
    read command

    # Add supported commands here.
    case $command in
        "exit")
            echo "Exiting the script. Goodbye!"
            break
            ;;
        "terminal length 0")
            echo ""
            ;;
        "show version")
            echo " -- MockOS 1.0 Platinum license (c) Workday all rights reserved."
            ;;
        "show inventory")
            echo 'NAME: "SSHd chassis",  DESCR: "MockOS shell"'
            ;;
        "show running-config")
            echo "username admin password 5 thisisaverysecretpassword role network-admin"
            ;;
        *) # Default case
            echo "ERROR"
            ;;
    esac
done
