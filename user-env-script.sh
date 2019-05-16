#!/bin/bash
# Name: user-env-script.sh
# Purpose: Get all users shell and environment variables
# Author: Mohammed Tanvirul Islam
################################################################

## Files name ##
file_excel="users_env_$(hostname).xls"
file_txt="users_env_$(hostname).txt"
file_csv="users_env_$(hostname).csv"

## Folder name ##
folder_name="exported_users_env_$(hostname)_$(date +"%d-%m-%Y")"

## Create folder ##
if [ -d "$folder_name" ]
then
  rm -rf ./$folder_name
  mkdir ./$folder_name
else
  mkdir ./$folder_name
fi
echo -e '\n'"Folder created: " $(pwd)/$folder_name'\n'


## write header to excel and csv ##
#echo -e "user" '\t' "shell" '\t' "variables" >> ./$folder_name/$file_txt
echo -e "user" '\t' "shell" '\t' "variables" >> ./$folder_name/$file_excel
echo -e "user, shell, variables" >> ./$folder_name/$file_csv

## Get all users name name starts with UE ##
users=$(ls -l /home/ | grep "^d" | awk -F" " '{print $9}')

## Write to files ##
for user in $users; do

  echo $user " >> " $file_txt, $file_excel, $file_csv
  user_shell=$(su - $user -c env | grep "SHELL=" | awk -F "SHELL=" '{print $2}')

  ## Write to text file ##
  echo "------------------------------[ $user : $user_shell ]------------------------------">> ./$folder_name/$file_txt
  su - $user -c env >> ./$folder_name/$file_txt
  echo "---------------------------------------[ FIN ]--------------------------------------" >> ./$folder_name/$file_txt
  echo -e '\n\n' >> ./$folder_name/$file_txt

  ## Write to excel file ##
  write_count=1
  for user_env in $(su - $user -c env); do
    if [ $write_count == 1 ]; then
      echo -e $user '\t' $user_shell '\t' $user_env >> ./$folder_name/$file_excel
    else
      echo -e "" '\t' "" '\t' $user_env >> ./$folder_name/$file_excel
    fi
    write_count=`expr $write_count + 1`
  done
  echo -e '\n\n' >> ./$folder_name/$file_excel

  ## Write to csv file ##
  echo "$(echo $user)","$(echo $user_shell)","$(su - $user -c env | paste -sd "$")" >> ./$folder_name/$file_csv

done
