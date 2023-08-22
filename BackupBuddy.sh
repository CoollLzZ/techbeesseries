#!/bin/bash


# ASCII art for backupbuddy
cat << "EOF"
  ____             _                ____            _     _
 |  _ \           | |              |  _ \          | |   | |
 | |_) | __ _  ___| | ___   _ _ __ | |_) |_   _  __| | __| |_   _
 |  _ < / _` |/ __| |/ / | | | '_ \|  _ <| | | |/ _` |/ _` | | | |
 | |_) | (_| | (__|   <| |_| | |_) | |_) | |_| | (_| | (_| | |_| |
 |____/ \__,_|\___|_|\_\\__,_| .__/|____/ \__,_|\__,_|\__,_|\__, |
                             | |                             __/ |
                             |_|                            |___/
EOF

# Check for tar utility is available or not
which tar &>> /dev/null
if [ $? -ne 0 ]; then
        sudo yum install tar -y &>> /dev/null
        echo tar utility is not available but now installed!
fi

# Check for zip utility is available or not
which zip &>> /dev/null
if [ $? -ne 0 ]; then
        sudo yum install unzip -y &>> /dev/null
        echo unzip utility is not available but now installed!
fi

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# Function to display menu table
display_menu() {
        # Print table header with colored text
        printf "${BLUE}%-10s ${RED}%-10s${RESET}\n" "Choice" "Select Backup Tool"
        printf "${BLUE}%-10s %-10s${RESET}\n" "-------" "----------------------------------------------"

        # Print table rows with colored text
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "01" "Tar Archive"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "02" "Tar (gzip)"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "03" "Tar (bzip2)"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "04" "Zip Archive"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "Quit" "Exit from the tool"
}

# Function to create a single file backup with compression choice
create_single_file_backup() {
    compression_choice="$1"

    read -p "Enter the path of the file: " file_path

    if [ -z "$file_path" ]; then
        echo "No file selected. Exiting."
        return
    fi

    read -p "Enter the backup file path: " backup_path

    if [ -z "$backup_path" ]; then
        backup_path="."
    fi

    file_name=$(basename "$file_path")

    case "$compression_choice" in
        1)
            compression_extension=".tar"
            backup_name="${file_name}_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvf "$backup_path/$backup_name" "$file_path" &>> /dev/null
            ;;
        2)
            compression_extension=".tar.gz"
            backup_name="${file_name}_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvzf "$backup_path/$backup_name" "$file_path" &>> /dev/null
            ;;
        3)
            compression_extension=".tar.bz2"
            backup_name="${file_name}_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvjf "$backup_path/$backup_name" "$file_path" &>> /dev/null
            ;;
        4)
            compression_extension=".zip"
            backup_name="${file_name}_$(date +'%Y-%m-%d')$compression_extension"
            zip "$backup_path/$backup_name" "$file_path" &>> /dev/null
            ;;
        *)
            echo "Invalid compression format choice. Exiting."
            return
            ;;
    esac


    echo -e "${GREEN}Backup created: $backup_path/$backup_name${RESET}"
}

# Function to create a multiple file tar backup with compression choice
create_multiple_files_backup() {
    compression_choice="$1"

    files=()

    while true; do
        read -p "Add file (Q-Quit): " file_path
        if [ "$file_path" == "Q" ]; then
            break
        elif [ -z "$file_path" ]; then
            continue  # Skip empty input
        fi

        if [ ! -f "$file_path" ]; then
            echo "File '$file_path' not found. Please enter a valid file path."
            continue
        fi

        files+=("$file_path")
    done

    if [ "${#files[@]}" -eq 0 ]; then
        echo "No files selected. Exiting."
        return
    fi

    read -p "Enter the backup directory path: " backup_path

    if [ -z "$backup_path" ]; then
        backup_path="."
    fi

    case "$compression_choice" in
        1)
            compression_extension=".tar"
            backup_name="$(basename "${files[0]}")_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvf "$backup_path/$backup_name" -C "$(dirname "${files[0]}")" "${files[@]}" &>> /dev/null
            ;;
        2)
            compression_extension=".tar.gz"
            backup_name="$(basename "${files[0]}")_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvzf "$backup_path/$backup_name" -C "$(dirname "${files[0]}")" "${files[@]}" &>> /dev/null
            ;;
        3)
            compression_extension=".tar.bz2"
            backup_name="$(basename "${files[0]}")_$(date +'%Y-%m-%d')$compression_extension"
            tar -cvjf "$backup_path/$backup_name" -C "$(dirname "${files[0]}")" "${files[@]}" &>> /dev/null
            ;;
        4)
           compression_extension=".zip"
           backup_name="$(basename "${files[0]}")_$(date +'%Y-%m-%d')$compression_extension"
           zip "$backup_path/$backup_name" "$(dirname "${files[0]}")" "${files[@]}" &>> /dev/null
            ;;
        *)
            echo "Invalid compression format choice. Exiting."
            return
            ;;
    esac

    echo -e "${GREEN}Backup created: $backup_path/$backup_name${RESET}"
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
            # Selected tar Backup Tool
            clear
            read -p "Single file or Multiple files (S/M): " choice
            case "$choice" in
                    S|s) create_single_file_backup 1;;
                    M|m) create_multiple_files_backup 1;;
                    *) echo "Invalid choice" ;;
            esac
           ;;
          2)
            # Selected tar with gzip Backup Tool
            clear
            read -p "Single file or Multiple files (S/M): " choice
            case "$choice" in
                    S|s) create_single_file_backup 2;;
                    M|m) create_multiple_files_backup 2;;
                    *) echo "Invalid choice" ;;
            esac
            ;;
          3)
            # Selected tar with bzip2 Backup Tool
            clear
            read -p "Single file or Multiple files (S/M): " choice
            case "$choice" in
                    S|s) create_single_file_backup 3;;
                    M|m) create_multiple_files_backup 3;;
                    *) echo "Invalid choice" ;;
            esac
            ;;
          4)
            # Selcted Zip Backup Tool
            clear
            read -p "Single file or Multiple files (S/M): " choice
            case "$choice" in
                    S|s) create_single_file_backup 4;;
                    M|m) create_multiple_files_backup 4;;
                    *) echo "Invalid choice" ;;
            esac
            ;;
          *)
            echo
            echo -e "${RED}Invalid choice${RESET}"
            echo
            ;;
        esac
done
