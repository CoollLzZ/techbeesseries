#!/bin/bash


# ASCII art for welcome to systeminfo
cat << "EOF"
    ____                  ____                 
   / __ \____ ___________/ __ \____ ___________
  / /_/ / __ `/ ___/ ___/ /_/ / __ `/ ___/ ___/
 / ____/ /_/ (__  |__  ) ____/ /_/ (__  |__  ) 
/_/    \__,_/____/____/_/    \__,_/____/____/  
                                               
EOF


# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD_RED='\033[1;31m'

# Making some spacing
echo
echo
echo



# Function to display menu table
display_menu() {
        # Print table header with colored text
        printf "${BLUE}%-10s ${RED}%-10s${RESET}\n" "Choice" "Information"
        printf "${BLUE}%-10s %-10s${RESET}\n" "-------" "-----------------------------"

        # Print table rows with colored text
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "01" "Check Your Password"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "02" "Generate secure password"
        printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "Quit" "Exit from the tool"
}

# Function to generate a random password
# Function to generate a random password
generate_password() {
    local password=""
    local uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lowercase="abcdefghijklmnopqrstuvwxyz"
    local numbers="0123456789"
    local specials="@#$%&*"

    # Add one uppercase, one lowercase, one number, and one special character
    password+="${uppercase:$((RANDOM % ${#uppercase})):1}"
    password+="${lowercase:$((RANDOM % ${#lowercase})):1}"
    password+="${numbers:$((RANDOM % ${#numbers})):1}"
    password+="${specials:$((RANDOM % ${#specials})):1}"

    # Add remaining characters randomly
    local all_characters="${uppercase}${lowercase}${numbers}${specials}"
    local remaining_length=6

    while (( remaining_length > 0 )); do
        local char="${all_characters:$((RANDOM % ${#all_characters})):1}"
        password+="$char"
        ((remaining_length--))
    done

    # Shuffle the password
    password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')

    echo "$password"
}

# Function to calculate the length of the password
get_password_length() {
    local input=$1
    local length=${#input}
    echo "$length"
}

# Function to count uppercase letters
get_uppercase_count() {
    local input=$1
    local count=$(echo "$input" | grep -o "[[:upper:]]" | wc -l)
    echo "$count"
}

# Function to count lowercase letters
get_lowercase_count() {
    local input=$1
    local count=$(echo "$input" | grep -o "[[:lower:]]" | wc -l)
    echo "$count"
}

# Function to count special characters
get_special_count() {
    local input=$1
    local count=$(echo "$input" | grep -o "[^[:alnum:]]" | wc -l)
    echo "$count"
}

# Function to count integers or numbers
get_number_count() {
    local input=$1
    local count=$(echo "$input" | grep -o "[[:digit:]]" | wc -l)
    echo "$count"
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
            # Get password from user
            read -s -p "Enter a password: " password

            # Check the password length
            while (( ${#password} < 10 )) || ! [[ $password =~ [[:upper:]] ]] || ! [[ $password =~ [[:lower:]] ]] || ! [[ $password =~ [^[:alnum:]] ]] || ! [[ $password =~ [[:digit:]] ]]; do
                echo
                echo -e "${BOLD_RED}Password requirements:${RESET}"
                echo -e "${CYAN} - The password should be 10 characters or longer.${RESET}"
                echo -e "${CYAN} - The password must include at least one uppercase letter,${RESET}"
                echo -e "${CYAN} - one lowercase letter, one special character, and one number.${RESET}"

                echo
                printf "${BLUE}%-10s %-10s${RESET}\n" "-------" "-----------------------------"
                printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "01" "Generate a random password"
                printf "${GREEN}%-10s ${YELLOW}%-10s${RESET}\n" "02" "Enter a custom password"
                echo
                
                # Read choice from the user
                read -p "Enter your choice: " newChoice
                
                # Remove leading zeros from the choice eg. 01
                newChoice=$(echo "$newChoice" | sed 's/^0*//')
                
                case $newChoice in
                  1) 
                    # Generate a random password
                    password=$(generate_password)
                    echo $password > /tmp/passpass
                    echo
                    echo -e "${MAGENTA}Random password is saved at /tmp/passpass${RESET}"
                    ;;
                    
                  2)
                    # Getting Password Manually
                    read -s -p "Enter Your New Password: " password
                    ;;
                     
                  *)
                    echo
                    echo -e "${RED}Invalid choice${RESET}"
                    echo
                    ;;
                esac
            
            done

            
            # Count the number of uppercase, lowercase, special characters, and numbers
            uppercase_count=$(get_uppercase_count "$password")
            lowercase_count=$(get_lowercase_count "$password")
            special_count=$(get_special_count "$password")
            number_count=$(get_number_count "$password")
            
            
            # Print the results
            echo -e "${GREEN}Amazing! it's an strong password!${RESET}" 
            echo -e "${CYAN}Password length: $(get_password_length "$password")${RESET}"
            echo -e "${CYAN}Uppercase letters: $uppercase_count${RESET}"
            echo -e "${CYAN}Lowercase letters: $lowercase_count${RESET}"
            echo -e "${CYAN}Special characters: $special_count${RESET}"
            echo -e "${CYAN}Numbers: $number_count${RESET}"
            echo
            ;;
            
          2)
            # Generate Random Password
            random_password=$(generate_password)
            echo $password > /tmp/passpass
            echo
            echo -e "${MAGENTA}Random password is saved at /tmp/passpass${RESET}"
            ;;
          *)
            echo
            echo -e "${RED}Invalid choice${RESET}"
            echo
            ;;
        esac
done

