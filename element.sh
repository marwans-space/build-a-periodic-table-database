#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit;
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
  QUERY=$($PSQL "SELECT name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1;")
  if [[ -z $QUERY ]]; then
   echo "I could not find that element in the database."
   exit ;
   fi
  IFS="|" read -r NAME SYMBOL MASS MELT BOIL TYPE <<< "$QUERY"
  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
else 
 QUERY=$($PSQL "SELECT elements.atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1';")
 if [[ -z $QUERY ]]; then
   echo "I could not find that element in the database."
   exit ;
   fi
  IFS="|" read -r NUMBER NAME SYMBOL MASS MELT BOIL TYPE <<< "$QUERY"
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi
