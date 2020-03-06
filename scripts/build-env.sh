#!/bin/bash

echo "Generating App config file."

filename=./app-config.js

if [[ $NODE_ENV == "development" ]]; then
    filename=./app/public/app-config.js
fi

# Recreate config file
rm -rf $filename
touch $filename

# Add assignment 
echo "window.APP_CONFIG = {" >> $filename

if [[ $NODE_ENV == "development" ]]; then
echo "Env is: $NODE_ENV"
    while read -r line || [[ -n "$line" ]];
    do
        # Split env variables by character `=`
        if printf '%s\n' "$line" | grep -q -e '='; then
            varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
            varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
        fi

        # Read value of current variable if exists as Environment variable
        value=$(printf '%s\n' "${!varname}")
        # Otherwise use value from .env file
        [[ -z $value ]] && value=${varvalue}
        
        # Append configuration property to JS file
        echo "  $varname: \"$value\"," >> $filename
    done < .env
else
    compgen -v | while read line; 
    do 
        if [[ $line =~ ^(REACT_APP_).* ]]; then
            echo "\"$line\":\"${!line}\"," >> $filename
        fi
    done
fi

echo "}" >> $filename

echo "Done ✅"