#!/bin/bash

# Read the datbase setting and store them in variables 
settings=$( echo "sites/default/settings.php" );
database=$( cat "${settings}" | grep "'database' =>" | grep -v "*" | grep -v "#" | sed -n "s/'database' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;
username=$( cat "${settings}" | grep "'username' =>" | grep -v "*" | grep -v "#" | sed -n "s/'username' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;
password=$( cat "${settings}" | grep "'password' =>" | grep -v "*" | grep -v "#" | sed -n "s/'password' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//') ;

# Print the results in varaibles (and with color highlighting)
echo -en "\n" && \
echo -en "\n" && \
echo -en "\n \e[1;31m Settings: [\e[1;33m${settings}\e[1;31m] \e[0m" && \
echo -en "\n \e[1;31m Database: [\e[1;33m${database}\e[1;31m] \e[0m" && \
echo -en "\n \e[1;31m Username: [\e[1;33m${username}\e[1;31m] \e[0m" && \
echo -en "\n \e[1;31m Password: [\e[1;33m${password}\e[1;31m] \e[0m" && \
echo -en "\n" && \
echo -en "\n";
