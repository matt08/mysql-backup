#!/bin/bash

# Definiowanie danych logowania do MySQL
USER="username"
PASSWORD="password"
HOST="localhost"

# Definiowanie miejsca przechowywania backupu
BACKUP_DIR="backup"

# Usuwanie starych kopii zapasowych
rm $BACKUP_DIR/*

# Definiowanie formatu nazwy pliku backupu
DATE=$(date +%Y%m%d%H%M)

# Tworzenie kopii zapasowej każdej bazy danych
databases=$(mysql --user=$USER --password=$PASSWORD --host=$HOST -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Tworzenie kopii zapasowej bazy danych $db."
        mysqldump --force --opt --user=$USER --password=$PASSWORD --host=$HOST --databases $db | gzip > "$BACKUP_DIR/$db-$DATE.gz"
    fi
done
