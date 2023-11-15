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
echo "" && \
echo "" && \
echo " \033[0;31m | Settings: [\033[0;33m${settings}\033[0;31m] \033[0m"
echo " \033[0;31m | Database: [\033[0;33m${database}\033[0;31m] \033[0m"
echo " \033[0;31m | Username: [\033[0;33m${username}\033[0;31m] \033[0m"
echo " \033[0;31m | Password: [\033[0;33m${password}\033[0;31m] \033[0m"
echo "" && \
echo ""

# user input: prompt for user to input the filepath
# echo " \033[0;31m # Import/Export-file: <\033[0;33m" && read -p "123" file_in_out
read -rp $'\e[1m'"# Import/Export-file: \033[0;32m" file_in_out$'\e[0m'
echo " \033[0;31m # Import-cmd:         <\033[0;33m  \033[0;31m mmysql -u $username -p"$password" "$database" < '$file_in_out' \\033[0m";
echo " \033[0;31m # Export-cmd:         <\033[0;33m  \033[0;31m mysqldump -u $username -p"$password" "$database" > "$file_in_out" \\033[0m";
echo ""

# =================
# delete database ?
echo " \033[0;31m # Delete-table (y/n): <\033[0;33m"  && read delete_tables && echo "\\033[0m"
if [[ "$delete_tables" == "y" ]]; then echo "Deleting  Table: "
    echo ""
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
    echo "Deleting Table: "
    mysql -u "$username" -p"$password" -e "USE $database; SHOW TABLES;" | grep -v Tables_in | while read -r table; do mysql -u "$username" -p"$password" -e "USE $database; DROP TABLE $table;"; done
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
fi #>/dev/null && fi

# =================
# export database ?
echo " \033[0;31m # Export-table (y/n): <\033[0;33m"  && read export_tables && echo "\\033[0m"
if [[ "$export_tables" == "y" ]]; then
    echo ""
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
    echo "Exporting Table: "
    mysqldump -u "$username" -p"$password" "$database" > "$file_in_out"
    printf '%*s\n' "$split_line_length" '' | tr ' ' '-'
fi #>/dev/null && fi

# =================
# export database ?
echo " \033[0;31m # Import-table (y/n): <\033[0;33m"  && read import_tables && echo "\\033[0m"
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