#!/bin/bash

# Read the datbase setting and store them in variables
split_line_length=100
settings=$( echo "sites/default/settings.php" )
database=$( cat "${settings}" | grep "'database' =>" | grep -v "*" | grep -v "#" | sed -n "s/'database' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//' )
username=$( cat "${settings}" | grep "'username' =>" | grep -v "*" | grep -v "#" | sed -n "s/'username' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//' )
password=$( cat "${settings}" | grep "'password' =>" | grep -v "*" | grep -v "#" | sed -n "s/'password' => '\([^']*\)'.*/\1/p" | sed -e 's/^[[:space:]]*//' )

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
echo -en " \e[1;31m | Settings: [\e[1;33m${settings}\e[1;31m] \e[0m\n"
echo -en " \e[1;31m | Database: [\e[1;33m${database}\e[1;31m] \e[0m\n"
echo -en " \e[1;31m | Username: [\e[1;33m${username}\e[1;31m] \e[0m\n"
echo -en " \e[1;31m | Password: [\e[1;33m${password}\e[1;31m] \e[0m\n"
echo ""

# user input: prompt for user to input the filepath
echo -en " \e[1;31m # Import/Export-file: <\e[1;33m"  && read file_in_out
echo -en " \e[1;31m # Import-cmd:         <\e[1;33m"  && echo -e "\e[1;33    mmysql -u $username -p"$password" "$database" < '$file_in_out' \e[0m";
echo -en " \e[1;31m # Export-cmd:         <\e[1;33m"  && echo -e "\e[1;33 mysqldump -u $username -p"$password" "$database" > "$file_in_out" \e[0m";
echo ""

# =================
# delete database ?
echo -en " \e[1;31m # Delete-table (y/n): <\e[1;33m"  && read delete_tables && echo -en "\e[0m"
if [[ "$delete_tables" == "y" ]]; then echo "Deleting  Table: "
    echo ""
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
    echo "Deleting Table: "
    mysql -u "$username" -p"$password" -e "USE $database; SHOW TABLES;" | grep -v Tables_in | while read -r table; do mysql -u "$username" -p"$password" -e "USE $database; DROP TABLE $table;"; done
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
fi #>/dev/null && fi

# =================
# export database ?
echo -en " \e[1;31m # Export-table (y/n): <\e[1;33m"  && read export_tables && echo -en "\e[0m"
if [[ "$export_tables" == "y" ]]; then
    echo ""
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
    echo "Exporting Table: "
    mysqldump -u "$username" -p"$password" "$database" > "$file_in_out"
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
fi #>/dev/null && fi

# =================
# export database ?
echo -en " \e[1;31m # Import-table (y/n): <\e[1;33m"  && read import_tables && echo -en "\e[0m"
if [[ "$import_tables" == "y" ]]; then
    echo ""
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
    echo "Importing Table: "
    mysql -u "$username" -p"$password" "$database" < "$file_in_out"
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
fi #>/dev/null && fi

# =================


# Unset commands reads
unset settings
unset database
unset username
unset password
unset delete_tables
unset import_tables
unset export_tables