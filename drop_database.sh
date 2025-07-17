#!/bin/bash

DB_NAME="demo"
HOST="89.104.70.35"

# Проверяем, существует ли база данных:
if psql -U postgres -d postgres -c "\l" | grep -qw "$DB_NAME"; then  
   # Если база данных существует, запрашиваем подтверждение на удаление:
   read -p "Вы уверены, что хотите удалить базу данных '$DB_NAME'? (y/n): " confirm  

   if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
     # Удаляем базу данных:
     psql -U postgres -d postgres -h $HOST  -c "DROP DATABASE $DB_NAME;"  
     echo "База данных '$DB_NAME' удалена."
   else
     echo "Удаление прервано."
   fi
else
   echo "База данных '$DB_NAME' не существует."
fi
