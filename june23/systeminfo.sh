#!/bin/bash

# ASCII art for welcome to systeminfo
cat << "EOF"
               _                            _                        _                 _        __
              | |                          | |                      | |               (_)      / _|
 __      _____| | ___ ___  _ __ ___   ___  | |_ ___    ___ _   _ ___| |_ ___ _ __ ___  _ _ __ | |_ ___
 \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \  / __| | | / __| __/ _ \ '_ ` _ \| | '_ \|  _/ _ \
  \ V  V /  __/ | (_| (_) | | | | | |  __/ | || (_) | \__ \ |_| \__ \ ||  __/ | | | | | | | | | || (_) |
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/  |___/\__, |___/\__\___|_| |_| |_|_|_| |_|_| \___/
                                                            __/ |
                                                           |___/
EOF

# ASCII art for Generator
cat << "EOF"
                                   _____                           _
                                  / ____|                         | |
                                 | |  __  ___ _ __   ___ _ __ __ _| |_ ___  _ __
                                 | | |_ |/ _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|
                                 | |__| |  __/ | | |  __/ | | (_| | || (_) | |
                                  \_____|\___|_| |_|\___|_|  \__,_|\__\___/|_|
EOF

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# Making some spacing
echo
echo
echo

# Function to display menu table
display_menu() {
        # Print table header with colored text
        printf "${BLUE}%-10s ${RED}%-10s${RESET}\n" "Choice" "Information"
        printf "${BLUE}%-10s %-10s${RESET}\n" "-------" "----------------------------------------------"

        # Print table rows with colored text
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "01" "Currently logged users"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "02" "Your Shell Directory"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "03" "Home Directory"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "04" "OS name & Version"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "05" "Current working directory"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "06" "Number of users logged in"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "07" "Show all available shells in your system"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "08" "Hard disk information"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "09" "CPU information"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "10" "Memory information"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "11" "File system information"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "12" "Currently running process"
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
            # Check currently logged-in users
            logged_in_users=$(who | cut -d' ' -f1)

            # Print the list of logged-in users
            echo
            echo "Currently logged-in users:"
            echo -e "${BLUE}$logged_in_users${RESET}"
            echo
            ;;
          2)
            # Retrieve the shell directory
            shell_directory=$(echo $SHELL)

            #  Print the shell directory
            echo
            echo -e "Your shell directory is: ${BLUE}$shell_directory${RESET}"
            echo
            ;;
          3)
            # Retrieve the home directory
            home_directory=~

            # Print the home directory
            echo
            echo -e "Your home directory is: ${BLUE}$home_directory${RESET}"
            echo
            ;;
          4)
            # Retrieve the OS name and version from release files
            os_name=$(cat /etc/os-release | grep -oP 'NAME="\K[^"]+')
            os_version=$(cat /etc/os-release | grep -oP 'VERSION_ID="\K[^"]+')

            # Print the OS name and version
            echo
            echo -e "Operating System: ${RED}$os_name${RESET}"
            echo -e "Version: ${GREEN}$os_version${RESET}"
            echo
            ;;
          5)
            # Retrieve the current working directory
            current_directory=$(pwd)

            # Print the current working directory
            echo
            echo -e "Current working directory: ${BLUE}$current_directory${RESET}"
            echo
            ;;
          6)
            # Retrieve the number of users logged in
            num_users=$(who | wc -l)

            # Print the number of users logged in
            echo
            echo -e "Number of users logged in: ${MAGENTA}$num_users${RESET}"
            echo
            ;;
          7)
            # Retrieve and display available shells
            echo
            echo -e "${CYAN}Available shells:${RESET}"
            cat /etc/shells
            echo
            ;;
          8)
            # Retrieve hard disk information using lsblk
            hard_disk_info=$(lsblk)

            # Print hard disk information
            echo
            echo "Hard Disk Information:"
            echo "$hard_disk_info"
            echo
            ;;
          9)
            # Retrieve CPU information using lscpu
            cpu_info=$(lscpu)

            # Print CPU information
            echo
            echo "CPU Information:"
            echo "$cpu_info"
            echo
            ;;
          10)
             # Retrieve memory information using free
             memory_info=$(free -h)

             # Print memory information
             echo
             echo "Memory Information:"
             echo "$memory_info"
             echo
             ;;
          11)
             # Retrieve file system information using df
             file_system_info=$(df -h)

             # Print file system information
             echo
             echo "File System Information:"
             echo "$file_system_info"
             echo
             ;;
          12)
             # Retrieve currently running processes using ps
             processes=$(ps aux)

             # Print currently running processes
             echo
             echo "Currently Running Processes:"
             echo "$processes"
             echo
             ;;
          *)
            echo
            echo -e "${RED}Invalid choice${RESET}"
            echo
            ;;
        esac
done
