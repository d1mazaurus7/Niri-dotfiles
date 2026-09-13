#!/usr/bin/env bash
hour=$(date +%H)
name=${USER:-friend}
if  [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
    echo "Good morning, $name!"
elif [ "$hour" -ge 12 ] && [ "$hour" -lt 18 ]; then
    echo "Good afternoon, $name!"
elif [ "$hour" -ge 18 ] && [ "$hour" -lt 23 ]; then
    echo "Good evening, $name!"
else
    echo "Good night, $name!"
fi
