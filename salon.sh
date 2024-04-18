#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
 if [[ $1 ]]
 then
  echo -e "\n$1"
 fi
  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "select service_id, name from services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-5]+$ ]]
  then
  MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      echo "What time would you like your cut, $CUSTOMER_NAME?"
      read SERVICE_TIME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    fi
  fi
}


MAIN_MENU