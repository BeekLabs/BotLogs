#!/usr/bin/bash

cat /var/log/auth.log | grep "Failed password for root from" | awk '{print $11}'|sort -u > failed2.txt
cat /var/log/auth.log | grep "Failed password for invalid user" | awk '{print$13}'|sort -u > failed.txt
cat /var/log/auth.log | grep "Accepted password for"| awk '{print$11}'|sort -u  > accepted.txt

input="accepted.txt"
    while IFS= read -r line
    do
        echo "🟢 Accepted password for" "$line" >> correct.txt
    done < "$input"

input="failed2.txt"
    while IFS= read -r line
    do
        echo "🔴 Failed password for root" "$line" >> fail.txt
        printf "IP Location: ";curl -s "https://ipinfo.io/$line"|egrep  -E -v '"readme": "https://ipinfo.io/missingauth"|ip'|tr "{}" " "|tr '"' ' '|tr "," " " >> fail.txt
    done < "$input"


input="failed.txt"
    while IFS= read -r line
    do
        echo "🔴 Failed password for invalid user" "$line" >> fail.txt
	printf "IP Location: ";curl -s "https://ipinfo.io/$line"|egrep  -E -v '"readme": "https://ipinfo.io/missingauth"|ip'|tr "{}" " "|tr '"' ' '|tr "," " " >> fail.txt
    done < "$input"


echo "Attempts in SSH login: " > logs.txt
date >> logs.txt
echo " " >> logs.txt

    cat correct.txt fail.txt >> logs.txt
    rm failed.txt failed2.txt correct.txt  accepted.txt fail.txt
    cat logs.txt

/usr/bin/python3 telegrambot.py
rm logs.txt
