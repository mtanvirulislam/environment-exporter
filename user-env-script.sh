#!/bin/bash
# Name: user-env-script.sh
# Purpose: Get all normal users type and environment variables
# Author: Mohammed Tanvirul Islam
################################################################
_login="/etc/login.defs"
_passwd="/etc/passwd"

## get mini UID limit ##
min_uid=$(grep "^UID_MIN" $_login)

## get max UID limit ##
max_uid=$(grep "^UID_MAX" $_login)

#File name
file="exported_user_env_$(hostname)_"`date +"%d-%m-%Y"`.txt
#Delete existing file
if [ -f "$file" ]
then
    rm -f ./$file
fi

#write header
#echo "user,type,variables" >> ./$file
## use awk to print if UID >= $MIN and UID <= $MAX and shell is not /sbin/nologin   ##
for user in $(awk -F':' -v "min=${min_uid##UID_MIN}" -v "max=${max_uid##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $1 }' "$_passwd"); do
  #user_type=$(getent passwd $user | awk -F':' '{ print $NF}')
  echo $user " >> " ./$file
  #echo "$(echo $user)","$(echo $user_type)","$(su - $user -c env | paste -sd "\n")" >> ./$file
  #echo ""
  echo "------------------------------[ $user : $(getent passwd $user | awk -F':' '{ print $NF}') ]------------------------------">> ./$file
  su - $user -c env >> ./$file
  echo "-------------------------------------[ FIN ]-------------------------------------" >> ./$file
  echo "">> ./$file
done
