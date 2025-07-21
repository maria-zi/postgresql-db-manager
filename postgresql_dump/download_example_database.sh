#!/bin/bash

DB_NAME="demo_small"                                         
DB_URL="https://edu.postgrespro.ru/demo-small-20161013.zip" 

# Загружаем файл по указанному URL и сохраняем его 
wget $DB_URL -O /tmp/database.zip         

# Распаковываем загруженный файл в директорию /tmp/database
gunzip /tmp/database.zip -d /tmp/database   

# Находим файл с расширением .sql в распакованной директории и сохраняем его путь в переменную SQL_FILE
SQL_FILE=$(find /tmp/database -name "*.sql" -print -quit)   

# Проверяем, существует ли файл SQL_FILE. Если существует, импортируем его в базу данных postgres 
if [ -f "$SQL_FILE" ]; then                                
  psql -U useradm -d postgres -f "$SQL_FILE"              
  echo "База данных загружена и импортирована из $SQL_FILE."
else
  echo "SQL файл не найден в распакованном архиве."
fi
