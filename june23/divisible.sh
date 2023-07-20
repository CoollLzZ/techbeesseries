#!/bin/bash

# Function to animate text output on shell.
animate_text() {
    local text="$1"
    local delay=0.05


    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:i:1}"
        sleep "$delay"
    done

    echo
}

# Function to validate if the input is an integer.
is_integer() {
    local input=$1
    if [[ $input =~ ^[0-9]+$ ]]; then
        return 0  # Input is an integer
    else
        return 1  # Input is not an integer
    fi
}


# Prompting the message as animated text.
echo
animate_text "Initiating number analysis. Determining if input value is divisible by 3 and 5."

# Declaring a boolean flag for while loop.
valid_input=false

# Loop will iterate until the valid input is not given.
while ! $valid_input; do
        animate_text "Please enter your number:"
        echo

        # Prompt the user for a number
        read  number
        echo

        # Validating the input is an integer only.
        if is_integer "$number"; then
                # Checking the number is Divisible by 3 & 5 Both or not.
                if (( number % 3 == 0 && number % 5 == 0 )); then
                        animate_text "DIVISIBLE"
                        echo
                else
                        animate_text "NOT DIVISIBLE"
                        echo
                fi
                valid_input=true
        else
                animate_text "Invalid input. Please enter a valid number."
                echo
        fi
done
