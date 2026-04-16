#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

#Crear MENU

echo -e "\n~~~HAIR SALOON APPOINTMENT~~~\n "

MAIN_MENU() {
  echo "Main"
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n ~~~ Welcome to the SALOON D'ORE, please choose a service ~~~ \n"
  SERVICE=$($PSQL "SELECT service_id, name FROM services;")
  #anadir counter para controlar cuantos sergicios hay
  echo "$SERVICE" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done 

  read SERVICE_ID_SELECTED

  NAME_SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $NAME_SELECTED_SERVICE ]]
  then
    MAIN_MENU "Please insert a valid service, read the memu with attention"

  else
    #pedir telefono
    echo "Please, insert your phone: "
    read CUSTOMER_PHONE #=$($PSQL "SELECT phone FROM customers")
    #con el telefono guardado hacer la busqueda en sql para ver si existe el tipo
    #arreglar aca!
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\n Please insert your name, since you are not registered yet"
      read CUSTOMER_NAME
      #insert client
      CUSTOMER_NAME_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      #echo "Welcome $CUSTOMER_NAME you are registered with $CUSTOMER_PHONE"
      echo "What time do you prefer to assist to the service?"
      read SERVICE_TIME
      echo "I have put you down for a $NAME_SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
      APPOINTMENT_ID_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    
    else
      echo "Welcome back, $CUSTOMER_NAME"
      echo "What time do you prefer to assist to the service?"
      read SERVICE_TIME
      echo "I have put you down for a $NAME_SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      APPOINTMENT_ID_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    #if the phone does exist:
    #create new customer
    #ask for name and use the previous inserted phone
    fi
  fi
}

#Appointments menu
APPOINTMENTS() {
  #the user exist (check with the phone)
  echo USER_EXIST
  #the user DOES NOT exists
  echo USER_NOT_EXISTS
}


MAIN_MENU
