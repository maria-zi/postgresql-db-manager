#!/bin/bash

DB_NAME="demo"
DUMP_DIR="/tmp/database"
DUMP_FILE=$(find ${DUMP_DIR} -name "${DB_NAME}_small_dump_*.sql" -print0 | xargs -0 ls -t | head -n 1)  

# Проверяем, существует ли база данных:
if psql -U postgres -d postgres -c "\l" | grep -qw "$DB_NAME"; then
  echo "База данных $DB_NAME существует."
  # Удаляем базу данных:
  psql -U postgres -d postgres -c "DROP DATABASE $DB_NAME;"
  
  if [ $? -ne 0 ]; then
    echo "Ошибка при удалении базы данных $DB_NAME."
    exit 1
  fi
  
  echo "База данных $DB_NAME была удалена."
  
else
  echo "База данных $DB_NAME не существует."
fi

# Проверяем, существует ли файл дампа:
if [ -f "$DUMP_FILE" ]; then
  # Создаем новую базу данных:
  psql -U postgres -d postgres -c "CREATE DATABASE $DB_NAME;"
  
  if [ $? -ne 0 ]; then
    echo "Ошибка при создании базы данных $DB_NAME."
    exit 1
  fi
  echo "База данных $DB_NAME создана."
 
  # Восстанавливаем базу данных из дампа:
  psql -U postgres -d $DB_NAME -f "$DUMP_FILE"

  if [ $? -ne 0 ]; then
    echo "Ошибка при восстановлении базы данных $DB_NAME из дампа $DUMP_FILE."
    exit 1
  fi
  
  echo "База данных $DB_NAME восстановлена из дампа $DUMP_FILE."
  
else
  echo "Файл дампа не найден в директории $DUMP_DIR."
fi
