#!/bin/bash
  
DB_FILENAME="demo_small"
DB_NAME="demo"
DUMP_FILE="/tmp/database/${DB_FILENAME}_dump_$(date +%Y-%m-%d).sql"
HOST="89.104.70.35"
  
# Проверяем, существует ли файл дампа:
if [ -f "$DUMP_FILE" ]; then
  echo "Ошибка: дамп за $(date +%Y-%m-%d) уже существует: $DUMP_FILE" >&2
else
  # Создаем дамп базы данных с использованием утилиты pg_dump и сохраняем его в указанный файл:
  pg_dump -U postgres -d $DB_NAME -f $DUMP_FILE -h $HOST
 
  # Проверяем результат выполнения pg_dump:
  if [ $? -eq 0 ]; then
    echo "Дамп базы данных создан: $DUMP_FILE"
  else
    echo "Ошибка при создании дампа базы данных" >&2
  fi
fi
