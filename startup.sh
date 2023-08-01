#!/bin/bash

# Run the systemctl command and capture the output
services_output=$(sudo systemctl list-unit-files | grep -E 'enabled|disabled')

# Initialize an empty dictionary
declare -A services_dict

# Loop through each line of the output
while IFS= read -r line; do
    # Extract the service name and status from each line
    service_name=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')

    # Add the service and its status to the dictionary
    services_dict["$service_name"]=$status
done <<< "$services_output"


# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# Check service
check_svc(){
        # Accept an argument service name '$svc'
        local operation=$1

        echo
        echo "No service named $1"
        echo
        echo "Finding services with name $1"
        echo "############################"
        sudo systemctl list-unit-files | grep -E 'enabled|disabled' | grep "$1"
        if [[ $? -ne 0 ]]; then
                        echo No Matching Services Found Named: "$1"
        fi

        echo
}

# Function to perform service start | stop | status Operation
operate_svc() {
    # Accept an argument called 'operation'
    local operation=$1

    read -p "Enter service name: " svc

    # Perform the specified operation (start or stop) based on the 'operation' argument
    case "$operation" in
        start)
            sudo systemctl start "$svc" &>> /dev/null
            if [[ $? -eq 0 ]]; then
                echo "$svc Started Successfully!"
                echo
            else
                    check_svc $svc
            fi
            ;;

        stop)
            sudo systemctl stop "$svc" &>> /dev/null
            if [[ $? -eq 0 ]]; then
                echo "$svc Stopped Successfully!"
                echo
            else
                    check_svc $svc
            fi
            ;;

        restart)
                sudo systemctl restart "$svc" &>> /dev/null
                if [[ $? -eq 0 ]]; then
                echo "$svc Restarted Successfully!"
                echo
            else
                    check_svc $svc
            fi
            ;;

        status)
               sudo systemctl status "$svc"
            ;;

        find)
             sudo systemctl list-unit-files | grep -E 'enabled|disabled' | grep $svc &>> /dev/null
             if [[ $? -eq 0 ]]; then
                     echo Available services named "$svc":
                     sudo systemctl list-unit-files | grep -E 'enabled|disabled' | grep $svc
                     echo

             else
                     echo No Matching Services Found Named: "$svc"
             fi
            ;;
        *)
            echo "Invalid operation. Please use start | stop | restart | status as the argument."
            ;;
    esac
}


# Function to display menu table
display_menu() {
        # Print table header with colored text
        printf "${BLUE}%-10s ${RED}%-10s${RESET}\n" "Choice" "Information"
        printf "${BLUE}%-10s %-10s${RESET}\n" "-------" "----------------------------------------------"

        # Print table rows with colored text
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "01" "Start an service"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "02" "Stop an service"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "03" "Restart an service"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "04" "Status of service"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "05" "Find a service"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "06" "List available services"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "Quit" "Exit from the tool"
}

# Loop until user enters 'q' or 'quit'
while true; do
        # Display the menu
        display_menu

        echo
        # Read choice from the user
        read -p "Enter your choice: " choice

        # Convert choice to lowercase
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

        # Check if the choice is 'q' or 'quit' to quit
        if [[ $choice == "q" || $choice == "quit" ]]; then
                break
        fi

        # Remove leading zeros from the choice eg. 01
        choice=$(echo "$choice" | sed 's/^0*//')

        # Compare the choice and perform actions using case statement
        case $choice in
          1)
            # Starting the service
            operate_svc start
           ;;
          2)
            # Stopping ther service
            operate_svc stop
            ;;
          3)
            # Restarting ther service
            operate_svc restart
            ;;
          4)
            # Status of a service
            operate_svc status
            ;;
          5)
            # Find the service is available in system
            operate_svc find
            ;;
          6)
            # Print the contents of the associative array (dictionary) in a formatted way
            printf "%-40s %s\n" "Service" "Status"
            printf "========================================\n"
            for service_name in "${!services_dict[@]}"; do
                    printf "%-40s %s\n" "$service_name" "${services_dict[$service_name]}"
            done
            ;;
          *)
            echo
            echo -e "${RED}Invalid choice${RESET}"
            echo
            ;;
        esac
done
