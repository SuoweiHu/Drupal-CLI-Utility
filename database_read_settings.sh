#!/bin/bash

# Read the datbase setting and store them in variables
settings=$( echo "sites/default/settings.php" );
database=$( cat "${settings}" | grep "'database' =>" | grep -v "*" | grep -v "#" | sed -n "s/'database' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;
username=$( cat "${settings}" | grep "'username' =>" | grep -v "*" | grep -v "#" | sed -n "s/'username' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;
password=$( cat "${settings}" | grep "'password' =>" | grep -v "*" | grep -v "#" | sed -n "s/'password' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;

# Check if any of the variable is empty, if yes them hault th program
if [[ -z "$database" ]]; then
    echo "Error: Variable 'database' is not set."
    return
fi
if [[ -z "$username" ]]; then
    echo "Error: Variable 'username' is not set."
    return
fi
if [[ -z "$password" ]]; then
    echo "Error: Variable 'password' is not set."
    return
fi

# Print the results in varaibles (and with color highlighting)
echo -en "\n \033[0;31m | Settings: [\033[0;33m${settings}\033[0;31m] \e[0m" && \
echo -en "\n \033[0;31m | Database: [\033[0;33m${database}\033[0;31m] \e[0m" && \
echo -en "\n \033[0;31m | Username: [\033[0;33m${username}\033[0;31m] \e[0m" && \
echo -en "\n \033[0;31m | Password: [\033[0;33m${password}\033[0;31m] \e[0m" && \
echo -en "\n" && \
echo -en "\n" && \
echo -en "\n";

# Unset commands reads
unset settings
unset database
unset username
unset password
