#!/bin/bash
java -jar fabric-server.jar --nogui --universe /temp/cache/ > >(tee /temp/app.log) 2>&1 &
PID=$!
tail -f /temp/app.log | while read LINE; do
    echo "$LINE" | grep -q "Done"
    if [ $? -eq 0 ]; then
        kill -SIGTERM $PID
        echo "============`fabric`安装完成============"
        exit 0
    fi
done
