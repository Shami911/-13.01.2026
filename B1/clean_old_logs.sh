#!/bin/bash
set -euo pipefail

if (( $# != 2 )); then
    echo "Error: enter 2 arguments"
    exit 1
fi
absolute_path=$1
if [[ -d "$absolute_path" ]]; then
    cd "$absolute_path"
    # echo "Перешли в папку - $absolute_path"
else
    echo "Error: No such file or directory" 
    exit 1
fi

day_count=$2
[[ "$day_count" =~ ^[0-9]+$ ]] || { echo "Error: enter a number"; exit 1; }
(( day_count > 0 )) || { echo "Error: enter a number greater than zero"; exit 1; }

 mapfile -t files < <(find . -maxdepth 1 -type f -name "*.log" -mtime +$day_count)
#  Если файлов нет проведем проверку
if (( ${#files[@]} == 0 )); then 
    echo "Нет логов старше $day_count дней не найдены"
    exit 0
fi
#Вывод массива 
echo "Обнаружены следующие файлы .log старше $day_count дней:"
for f in "${files[@]}"; do 
    echo "$f"
done

# Подтверждение удаления
read -r -p "Удалить эти файлы? (y/n)" answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    rm -f "${files[@]}"
    echo "Файлы удалены"
else
    echo "Операция отменена"
fi

# Задание B1: "Простой скрипт-помощник" (Bash)
# Задача: Напиши bash-скрипт clean_old_logs.sh, который:
# 1 Принимает два аргумента: путь к директории (/path/to/logs) и количество
# дней (N).
# 2 Находит в указанной директории все файлы с расширением .log, которые
# старше N дней.
# 3 Выводит список этих файлов на экран и запрашивает подтверждение:
# "Удалить эти файлы? (y/n)".
# 4 При подтверждении 'y' — удаляет их. При 'n' — завершает работу.
# 5 Если аргументы не переданы, выводит справку по использованию скрипта.