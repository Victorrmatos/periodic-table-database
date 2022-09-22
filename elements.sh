#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
ARG="$1"
number='^[0-9]+$'
symbol='^[a-zA-Z]{1,2}$'
name='[a-zA-Z]{3,20}'
ASK(){
if [[ -z $ARG ]]
then
echo Please provide an element as an argument.
else
if [[ $ARG =~ $number ]]
  then
  IN_DATABASE=$($PSQL"select name from elements where atomic_number = $ARG")
  if [[ ! -z $IN_DATABASE ]]
    then
    echo "The element with atomic number $ARG is$($PSQL "select name from elements where atomic_number = $ARG") ($(echo$($PSQL"select symbol from elements where atomic_number = $ARG")| sed -E 's/^ *| *$//g')). It's a$($PSQL "select type from types inner join properties using (type_id) where atomic_number = $ARG"), with a mass of $(echo $($PSQL "select atomic_mass from properties where atomic_number = $ARG")| sed -E 's/^ *| *$//g') amu. $(echo $($PSQL "select name from elements where atomic_number = $ARG")| sed -E 's/^ *| *$//g') has a melting point of $(echo $($PSQL "select melting_point_celsius from properties where atomic_number = $ARG")| sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $($PSQL "select boiling_point_celsius from properties where atomic_number = $ARG")| sed -E 's/^ *| *$//g') celsius."
    else echo "I could not find that element in the database."
  fi
else
if [[ $ARG =~ $symbol ]]
  then
  IN_DATABASE=$($PSQL "select name from elements where symbol = '$ARG'")
  if [[ ! -z $IN_DATABASE ]]
    then
    echo "The element with atomic number $(echo $($PSQL "select atomic_number from elements where symbol = '$ARG'")| sed -E 's/^ *| *$//g') is$($PSQL "select name from elements where symbol = '$ARG'") ($ARG). It's a$($PSQL "select type from types inner join properties using(type_id) inner join elements using(atomic_number)where symbol = '$ARG'"), with a mass of $(echo $($PSQL "select atomic_mass from properties inner join elements using (atomic_number) where symbol = '$ARG'")| sed -E 's/^ *| *$//g') amu. $(echo $($PSQL "select name from elements where symbol = '$ARG'")| sed -E 's/^ *| *$//g') has a melting point of $(echo $($PSQL "select melting_point_celsius from properties inner join elements using (atomic_number) where symbol = '$ARG'")| sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $($PSQL "select boiling_point_celsius from properties inner join elements using(atomic_number)where symbol = '$ARG'")| sed -E 's/^ *| *$//g') celsius."
  else echo "I could not find that element in the database."
  fi
  fi
if [[ $ARG =~ $name ]]
  then
  IN_DATABASE=$($PSQL "select symbol from elements where name = '$ARG'")
  if [[ ! -z $IN_DATABASE ]]
    then
    echo "The element with atomic number $(echo $($PSQL "select atomic_number from elements where name = '$ARG'")| sed -E 's/^ *| *$//g') is $ARG ($(echo$($PSQL "select symbol from elements where name = '$ARG'")| sed -E 's/^ *| *$//g')). It's a$($PSQL "select type from types inner join properties using (type_id) inner join elements using(atomic_number)where name = '$ARG'"), with a mass of $(echo $($PSQL "select atomic_mass from properties inner join elements using (atomic_number) where name = '$ARG'")| sed -E 's/^ *| *$//g') amu. $ARG has a melting point of $(echo $($PSQL "select melting_point_celsius from properties inner join elements using (atomic_number) where name = '$ARG'")| sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $($PSQL "select boiling_point_celsius from properties inner join elements using(atomic_number)where name = '$ARG'")| sed -E 's/^ *| *$//g') celsius."
  else echo "I could not find that element in the database."
  fi
fi
fi

fi
}
ASK
