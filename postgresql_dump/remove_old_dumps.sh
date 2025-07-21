#!/bin/bash

DUMP_DIR="/tmp/database"
DATE_THRESHOLD=$(date -d "-14 days" +%Y-%m-%d)

# Ищем файлы с датой в имени и удаляем те, которые старше 14 дней
find "$DUMP_DIR" -type f -name "*.sql" | 
while read -r file; do
  # Извлекаем дату из имени файла (формат YYYY-MM-DD)
  FILE_DATE=$(basename "$file" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")

  if [[ "$FILE_DATE" < "$DATE_THRESHOLD" ]]; then
    rm -f "$file"
    echo "$(date): Удален файл $file с датой $FILE_DATE" >> /var/log/delete_old_dumps.log
  fi
done
